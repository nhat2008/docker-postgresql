##################### POSTGRESQL #####################
BASE ON: PostgreSQL 9.0 High Performance by Gregory Smith

1. shared_buffer (how much memory is "DEDICATED" to PostgreSQL to use for caching data)
Some conventional wisdom that PostgreSQL doesn't handle large shared_buffers settings well

==> "allocate about 25% of system memory (RAM) to shared_buffers", as recommended by the official documentation and by the wiki article on Tuning Your PostgreSQL server, but not more than about 8GB on Linux or 512MB on Windows, and sometimes less -- Page 117

2. effective_cache_size (how much memory (RAM) is available for disk caching by the operating system and within the database itself, after taking into account what's used by the OS itself and other applications)
"This is a guideline for how much memory you expect to be available in the OS and PostgreSQL buffer caches, not an allocation!" This value is used only by the PostgreSQL query planner to figure out whether plans it's considering would be expected to fit in RAM or not

==>  rule of thumb that would set effective_cache_size to between 50 and 75 percent of RAM. -- Page 131
+++ The author used 72%.

3. work_mem (If you do a lot of complex sorts, and have a lot of memory, then increasing the work_mem parameter allows PostgreSQL to do larger in-memory sorts which, unsurprisingly, will be faster than disk-based equivalents.)

==> In practice, there aren't that many sorts going on in a typical query, usually only one or two. And
not every client that's active will be sorting at the same time. The normal guidance for work_mem
is to consider how much free RAM is around after shared_buffers is allocated (the same OS
caching size figure needed to compute effective_cache_size), divide by max_connections, and
then take a fraction of that figure; a half of that would be an aggressive work_mem value. In that
case, only if every client had two sorts active all at the same time would the server be likely to run
out of memory, which is an unlikely scenario. – Page 142
+++ Lloyd Albin, not Gregory Smith, author of "PostgreSQL 9.0 High Performance" used "total RAM / max_connections", without subtract RAM used by shared_buffers

4. maintenance_work_mem (maximum amount of memory to be used by maintenance operations, such as VACUUM, CREATE INDEX, and ALTER TABLE ADD FOREIGN KEY), only one of these operations can be executed at a time by a database session. Larger settings might improve performance for vacuuming and for restoring database dumps.

==> 25% of RAM / autovacuum_max_workers

5. checkpoint_segments (PostgreSQL writes new transactions to the database in files called WAL segments that are 16MB in size. Every time checkpoint_segments worth of these files have been written, by default 3, a checkpoint occurs. Checkpoints can be resource intensive, and on a modern system doing one every 48MB will be a serious performance bottleneck. Setting checkpoint_segments to a much larger value improves that. Unless you're running on a very small configuration, you'll almost certainly be better setting this to at least 10, which also allows usefully increasing the completion target.)

The general rule of thumb you can extract here is that for every 32 checkpoint segments, expect at least 1
GB of WAL files to accumulate. As database crash recovery can take quite a while to process even that much
data, 32 is as high as you want to make this setting for anything but a serious database server. The default of
3 is very low for most systems though; even a small install should consider an increase to at least 10.
Normally, you'll only want a value greater than 32 on a smaller server when doing bulk-loading, where it can
help performance significantly and crash recovery isn't important. Databases that routinely do bulk loads
may need a higher setting. -- Page 137

==> recommend using 32

6. wal_buffers (Increasing wal_buffers from its tiny default of a small number of kilobytes is helpful for write-heavy systems).  With the only downside being the increased use of shared memory, and as there's no case where more than a single WAL segment could need to be buffered

==> recommend using 32MB
Warning: Changing wal_buffers requires a database restart.


### Other parameters:
max_connections
max_locks_per_transaction
autovacuum_max_workers