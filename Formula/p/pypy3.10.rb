class Pypy310 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https:pypy.org"
  url "https:downloads.python.orgpypypypy3.10-v7.3.17-src.tar.bz2"
  sha256 "6ad74bc578e9c6d3a8a1c51503313058e3c58c35df86f7485453c4be6ab24bf7"
  license "MIT"
  revision 1
  head "https:github.compypypypy.git", branch: "main"

  livecheck do
    url "https:downloads.python.orgpypy"
    regex(href=.*?pypy3(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "311b947a1528ae90983edc2176864a00865fb678c13c2286efe24075463a1796"
    sha256 cellar: :any,                 arm64_sonoma:  "8276c86a74591aec5dcd72722caeaa9c5a950f922b77c5ac20fc1147e21698b5"
    sha256 cellar: :any,                 arm64_ventura: "9e80dff6aaa3e465055533fe201daa041baf2e24af5ea96dca4951b56a171589"
    sha256 cellar: :any,                 sonoma:        "cbac71c93a07a6e926836763d9d67662b157a12525ce5c333504a4e10eff14f6"
    sha256 cellar: :any,                 ventura:       "f8216079a9bc035470ac314f3dacaab40839ea20edc53b8fea250af4128612e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4032a756625270ffb7945d97b0116ac7e9acb1e5731eab7590241874f2fb12d"
  end

  depends_on "pkgconf" => :build
  depends_on "pypy" => :build
  depends_on "gdbm"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "tcl-tk@8"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  # setuptools >= 60 required sysconfig patch
  # See https:github.comHomebrewhomebrew-corepull99892#issuecomment-1108492321
  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesef752bc7bef4d668f9caa9c6ed3f3187989922765403198243040d08d2a52725setuptools-59.8.0.tar.gz"
    sha256 "09980778aa734c3037a47997f28d6db5ab18bdf2af0e49f719bfc53967fd2e82"
  end

  # always pull the latest pip, https:pypi.orgprojectpip#files
  resource "pip" do
    url "https:files.pythonhosted.orgpackagesb7066b1ad0ae8f97d7a0d6f6ad640db10780578999e647a9593512ceb6f06469pip-23.3.2.tar.gz"
    sha256 "7fd9972f96db22c8077a1ee2691b172c8089b17a5652a44494a9ecb0d78f9149"
  end

  # Build fixes:
  # - Disable Linux tcl-tk detection since the build script only searches system paths.
  #   When tcl-tk is not found, it uses unversioned `-ltcl -ltk`, which breaks build.
  # Upstream issue ref: https:github.compypypypyissues3538
  patch :DATA

  def abi_version
    stable.url[pypy(\d+\.\d+), 1]
  end

  def newest_abi_version?
    self == Formula["pypy3"]
  end

  def install
    # The `tcl-tk` library paths are hardcoded and need to be modified for non-usrlocal prefix
    tcltk = Formula["tcl-tk@8"]
    inreplace "lib_pypy_tkintertklib_build.py" do |s|
      s.gsub! "['usrlocalopttcl-tkinclude']", "[]"
      # We moved `tcl-tk` headers to `includetcl-tk` and versioned TCL 8
      # TODO: upstream this.
      s.gsub! "(homebrew + 'include')", "('#{tcltk.opt_include}tcl-tk')"
      s.gsub! "(homebrew + 'opttcl-tklib')", "('#{tcltk.opt_lib}')"
    end

    if OS.mac?
      # Allow python modules to use ctypes.find_library to find homebrew's stuff
      # even if homebrew is not a usrlocallib. Try this with:
      # `brew install enchant && pip install pyenchant`
      inreplace "lib-python3ctypesmacholibdyld.py" do |f|
        f.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
                "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}lib', "
        f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}Frameworks',"
      end
    end

    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https:github.comHomebrewhomebrewissues24364
    ENV["PYTHONPATH"] = nil
    ENV["PYPY_USESSION_DIR"] = buildpath

    python = Formula["pypy"].opt_bin"pypy"
    cd "pypygoal" do
      system python, buildpath"rpythonbinrpython",
             "-Ojit", "--shared", "--cc", ENV.cc, "--verbose",
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"

      with_env(PYTHONPATH: buildpath) do
        system ".pypy#{abi_version}-c", buildpath"lib_pypypypy_toolsbuild_cffi_imports.py"
      end
    end

    libexec.mkpath
    cd "pypytoolrelease" do
      package_args = %w[--archive-name pypy3 --targetdir . --no-make-portable --no-embedded-dependencies]
      system python, "package.py", *package_args
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy3.tar.bz2"
    end

    # The PyPy binary install instructions suggest installing somewhere
    # (like opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec"binpypy#{abi_version}"
    lib.install_symlink libexec"bin"shared_library("libpypy#{abi_version}-c")
    include.install_symlink libexec"includepypy#{abi_version}"

    if newest_abi_version?
      bin.install_symlink "pypy#{abi_version}" => "pypy3"
      lib.install_symlink shared_library("libpypy#{abi_version}-c") => shared_library("libpypy3-c")
    end

    return unless OS.linux?

    # Delete two files shipped which we do not want to deliver
    # These files make patchelf fail
    rm([libexec"binlibpypy#{abi_version}-c.so.debug", libexec"binpypy#{abi_version}.debug"])
  end

  def post_install
    # Precompile cffi extensions in lib_pypy
    # list from create_cffi_import_libraries in pypytoolreleasepackage.py
    %w[_sqlite3 _curses syslog gdbm _tkinter].each do |module_name|
      quiet_system bin"pypy#{abi_version}", "-c", "import #{module_name}"
    end

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    site_packages(HOMEBREW_PREFIX).mkpath
    touch site_packages(HOMEBREW_PREFIX)".keepme"
    rm_r(site_packages(libexec))

    # Symlink the prefix site-packages into the cellar.
    site_packages(libexec).parent.install_symlink site_packages(HOMEBREW_PREFIX)

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils"distutils.cfg").atomic_write <<~EOS
      [install]
      install-scripts=#{scripts_folder}
    EOS

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin"pypy#{abi_version}", "-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose"
      end
    end

    # Symlinks to pip_pypy3
    bin.install_symlink scripts_folder"pip#{abi_version}" => "pip_pypy#{abi_version}"
    symlink_to_prefix = [bin"pip_pypy#{abi_version}"]

    if newest_abi_version?
      bin.install_symlink "pip_pypy#{abi_version}" => "pip_pypy3"
      symlink_to_prefix << (bin"pip_pypy3")
    end

    # post_install happens after linking
    (HOMEBREW_PREFIX"bin").install_symlink symlink_to_prefix
  end

  def caveats
    <<~EOS
      A "distutils.cfg" has been written to:
        #{distutils}
      specifying the install-scripts folder as:
        #{scripts_folder}

      If you install Python packages via "pypy#{abi_version} setup.py install" or pip_pypy#{abi_version},
      any provided scripts will go into the install-scripts folder
      above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}bin
      so you don't overwrite tools from CPython.

      Setuptools and pip have been installed, so you can use pip_pypy#{abi_version}.
      To update pip and setuptools between pypy#{abi_version} releases, run:
          pip_pypy#{abi_version} install --upgrade pip setuptools

      See: https:docs.brew.shHomebrew-and-Python
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def site_packages(root)
    root"libpypy#{abi_version}site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX"sharepypy#{abi_version}"
  end

  # The Cellar location of distutils
  def distutils
    site_packages(libexec).parent"distutils"
  end

  test do
    newest_pypy3_formula_name = CoreTap.instance
                                       .formula_names
                                       .select { |fn| fn.start_with?("pypy3") }
                                       .max_by { |fn| Version.new(fn[\d+\.\d+$]) }

    assert_equal Formula["pypy3"],
                 Formula[newest_pypy3_formula_name],
                 "The `pypy3` symlink needs to be updated!"
    assert_equal abi_version, name[\d+\.\d+$]
    system bin"pypy#{abi_version}", "-c", "print('Hello, world!')"
    system bin"pypy#{abi_version}", "-c", "import time; time.clock()"
    system scripts_folder"pip#{abi_version}", "list"
  end
end

__END__
--- alib_pypy_tkintertklib_build.py
+++ blib_pypy_tkintertklib_build.py
@@ -17,7 +17,7 @@ elif sys.platform == 'win32':
     incdirs = []
     linklibs = ['tcl86t', 'tk86t']
     libdirs = []
-elif sys.platform == 'darwin':
+else:
     # homebrew
     homebrew = os.environ.get('HOMEBREW_PREFIX', '')
     incdirs = ['usrlocalopttcl-tkinclude']
@@ -26,7 +26,7 @@ elif sys.platform == 'darwin':
     if homebrew:
         incdirs.append(homebrew + 'include')
         libdirs.append(homebrew + 'opttcl-tklib')
-else:
+if False: # disable Linux system tcl-tk detection
     # On some Linux distributions, the tcl and tk libraries are
     # stored in usrinclude, so we must check this case also
     libdirs = []