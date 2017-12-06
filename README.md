Those are scripts to run hgeant simulations for HADES.

Installing Geant
================

Go to your lustre directory (see *manuals:Tips* repo for details). Create sim directory and enter it:
    mkdir hades/pp45/sim -p
    cd hades/pp45/sim/

Clone the repository:

    git clone https://github.com/HADES-Cracovia/geant geant
    cd geant

Source your profile (see *manuals:Tips* repo if you don't have profile yet), e.g. `. ../../profile/.sh` and install pluto generator.

    make
    make install

Usage
=====

HGenat uses `evt` files generated with Pluto (see *PlutoGen* repository). The input of the hgeant is a job card which must be prepared for each run. The job card contains all info about geomteries, tuples, sources, and output files. While usually geometries and tuples are the same for each run, you must change input and output. Therefor the job card is preapred as an template `simul.dat` and `job_script.sh` uses `sed` to replace plceholders and writes new file in the tmp directory which are used as a input for hgeant. After the job, the card is removed.

The jobs are send to a farm. To better organize files, each events of the same kind (simulation channel, etc.) are group into file lists. This list is then provided to `run_job.py` and split into individual files and each file simulated separately.

Preparing file lists
--------------------

The `gen_list.py` script is used to generate the lists of given files based on their name. The name is split into two parts, the core part and the rest. The core part is used to generate file list name, andall files with a given core name are put into that list. Example, if files are called `pluto_chan_xxx_events_10000_seed_????.evt`, the core part can be `pluto_chan_xxx_events_10000`. The spearator in this case is `_seed_` and `????.evt` are the files which belong to given list.

Usage:

    gen_lists.py [-h] [-s SEPARATOR] [-o OUTPUT] arguments [arguments ...]

where:

    -s SEPARATOR  -- is a sperataor string (default: _seed_)
    -o OUTPUT     -- is a output directory (default: ./)
    arguments     -- are files to be encapsulated in the lists

Running hgeant manually
-----------------------

One needs to copy `simul.dat` into a new file and replace two last lines of the fine with proper input and output files.

Usage:

    hgeant -b -c -f <job card>

where:

    -b             -- batch mode
    -c             -- don't remember :-)
    -f <job card>  -- take job card as a input

The outpt file is as given in the last line but with additional number (starting with 1) just before the extension. The output file, if huge, canb be split into several files up to 2 GB.

Using with a Batch Farm
----------------

It is possible to send jobs to the GSI batch farm. For that, two additional files `job_script.sh` and `run_job.py` are provided.

`job_script.sh` is a execution script and usually doesn't need any changes. The same for `run_job.py`.

To send jobs, execute following command:

    ./run_job args [-e events]

where `events` are optional (default: 10000) ang `args` can be multiple file lists. Argument can be also a single `evt` file but then `--file` switch must be passed to the `run_job.py` script.