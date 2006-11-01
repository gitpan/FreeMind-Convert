use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'FreeMind::Convert',
    VERSION_FROM      => 'lib/FreeMind/Convert.pm', # finds $VERSION
    PREREQ_PM         => {
        'XML::Simple'       => 0.01,
        'Class::Accessor'   => 0.01,
    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/FreeMind/Convert.pm', # retrieve abstract from module
       AUTHOR         => 'A. U. Thor <a.u.thor@a.galaxy.far.far.away>') : ()),
);
