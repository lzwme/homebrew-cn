class Pypy < Formula
  desc "Highly performant implementation of Python 2 in Python"
  homepage "https:pypy.org"
  url "https:downloads.python.orgpypypypy2.7-v7.3.18-src.tar.bz2"
  sha256 "737435ddfc5afa5b97a7209c87d70d5f1062426c053b9bb8b99a0347cb4891fa"
  license "MIT"
  head "https:github.compypypypy.git", branch: "main"

  livecheck do
    url "https:downloads.python.orgpypy"
    regex(href=.*?pypy2(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09b0a361e84c58a690a246f94c0f577b16203d6ae0c85f4d904cb7db3244e33a"
    sha256 cellar: :any,                 arm64_sonoma:  "dbb2e87968e8f93a0154e2c9fa552f6bd9937c86fac8e2bcbb3dcc53b1f5fbcf"
    sha256 cellar: :any,                 arm64_ventura: "fa95b16aa1a1f5e90b1b37cdf96f2e1b0ed5a15cc041fa08f4f9d4559d468efa"
    sha256 cellar: :any,                 sonoma:        "074caca2fea633d1e7dc10531e67f45de0ec1eb885c300aea99db85a7ce85776"
    sha256 cellar: :any,                 ventura:       "6e0cd5fc75060a6fb1a4e310e0ae382e3c51de81458257ab59a0a14cc951e23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50a0aa4c456336f1b37cc8274d2bd924483f454b466b9d1e1b4b3fa49b10759"
  end

  depends_on "pkgconf" => :build
  depends_on "gdbm"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "tcl-tk@8"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https:downloads.python.orgpypypypy2.7-v7.3.11-macos_arm64.tar.bz2"
        sha256 "cc5696ab4f93cd3481c1e4990b5dedd7ba60ac0602fa1890d368889a6c5bf771"
      end
      on_intel do
        url "https:downloads.python.orgpypypypy2.7-v7.3.11-macos_x86_64.tar.bz2"
        sha256 "56deee9c22640f5686c35b9d64fdb1ce3abd044583e4078f0b171ca2fd2a198e"
      end
    end
    on_linux do
      on_arm do
        url "https:downloads.python.orgpypypypy2.7-v7.3.11-aarch64.tar.bz2"
        sha256 "ea924da1defe9325ef760e288b04f984614e405580f5321eb6a5c8f539bd415a"
      end
      on_intel do
        url "https:downloads.python.orgpypypypy2.7-v7.3.11-linux64.tar.bz2"
        sha256 "ba8ed958a905c0735a4cfff2875c25089954dc020e087d982b0ffa5b9da316cd"
      end
    end
  end

  # > Setuptools as a project continues to support Python 2 with bugfixes and important features on Setuptools 44.x.
  # See https:setuptools.readthedocs.ioenlatestpython%202%20sunset.html#python-2-sunset
  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesb2404e00501c204b457f10fe410da0c97537214b2265247bc9a5bc6edd55b9e4setuptools-44.1.1.zip"
    sha256 "c67aa55db532a0dadc4d2e20ba9961cbd3ccc84d544e9029699822542b5a476b"
  end

  # > pip 20.3 was the last version of pip that supported Python 2.
  # See https:pip.pypa.ioenstabledevelopmentrelease-process#python-2-support
  resource "pip" do
    url "https:files.pythonhosted.orgpackages537f55721ad0501a9076dbc354cc8c63ffc2d6f1ef360f49ad0fbcce19d68538pip-20.3.4.tar.gz"
    sha256 "6773934e5f5fc3eaa8c5a44949b5b924fc122daa0a8aa9f80c835b4ca2a543fc"
  end

  # Build fixes:
  # - Disable Linux tcl-tk detection since the build script only searches system paths.
  #   When tcl-tk is not found, it uses unversioned `-ltcl -ltk`, which breaks build.
  patch :DATA

  def install
    # Work-around for build issue with Xcode 15.3
    # upstream bug report, https:github.compypypypyissues4931
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # Avoid statically linking to libffi
    inreplace "rpythonrlibclibffi.py", '"libffi.a"', "\"#{shared_library("libffi")}\""

    # The `tcl-tk` library paths are hardcoded and need to be modified for non-usrlocal prefix
    tcltk = Formula["tcl-tk@8"]
    inreplace "lib_pypy_tkintertklib_build.py" do |s|
      s.gsub! "['usrlocalopttcl-tkinclude']", "[]"
      s.gsub! "(homebrew + 'include')", "('#{tcltk.opt_include}tcl-tk')"
      s.gsub! "(homebrew + 'opttcl-tklib')", "('#{tcltk.opt_lib}')"
    end

    if OS.mac?
      # Allow python modules to use ctypes.find_library to find homebrew's stuff
      # even if homebrew is not a usrlocallib. Try this with:
      # `brew install enchant && pip install pyenchant`
      inreplace "lib-python2.7ctypesmacholibdyld.py" do |f|
        f.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
                "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}lib',"
        f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}Frameworks',"
      end
    end

    # See https:github.comHomebrewhomebrewissues24364
    ENV["PYTHONPATH"] = ""
    ENV["PYPY_USESSION_DIR"] = buildpath

    resource("bootstrap").stage buildpath"bootstrap"
    python = buildpath"bootstrapbinpypy"

    cd "pypygoal" do
      system python, "....rpythonbinrpython", "--opt", "jit",
                                                  "--cc", ENV.cc,
                                                  "--make-jobs", ENV.make_jobs,
                                                  "--shared",
                                                  "--verbose"
    end

    system python, "pypytoolreleasepackage.py", "--archive-name", "pypy",
                                                   "--targetdir", ".",
                                                   "--no-embedded-dependencies",
                                                   "--no-keep-debug",
                                                   "--no-make-portable"
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy.tar.bz2"

    # The PyPy binary install instructions suggest installing somewhere
    # (like opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec"binpypy"
    lib.install_symlink libexec"bin"shared_library("libpypy-c")
  end

  def post_install
    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    unless (libexec"site-packages").symlink?
      # fix the case where libexecsite-packagessite-packages was installed
      rm_r(libexec"site-packagessite-packages") if (libexec"site-packagessite-packages").exist?
      mv Dir[libexec"site-packages*"], prefix_site_packages
      rm_r(libexec"site-packages")
    end
    libexec.install_symlink prefix_site_packages

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils"distutils.cfg").atomic_write <<~INI
      [install]
      install-scripts=#{scripts_folder}
    INI

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin"pypy", "-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose"
      end
    end

    # Symlinks to easy_install_pypy and pip_pypy
    bin.install_symlink scripts_folder"easy_install" => "easy_install_pypy"
    bin.install_symlink scripts_folder"pip" => "pip_pypy"

    # post_install happens after linking
    %w[easy_install_pypy pip_pypy].each { |e| (HOMEBREW_PREFIX"bin").install_symlink bine }
  end

  def caveats
    <<~EOS
      A "distutils.cfg" has been written to:
        #{distutils}
      specifying the install-scripts folder as:
        #{scripts_folder}

      If you install Python packages via "pypy setup.py install", easy_install_pypy,
      or pip_pypy, any provided scripts will go into the install-scripts folder
      above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}bin
      so you don't overwrite tools from CPython.

      Setuptools and pip have been installed, so you can use easy_install_pypy and
      pip_pypy.
      To update setuptools and pip between pypy releases, run:
          pip_pypy install --upgrade pip setuptools

      See: https:docs.brew.shHomebrew-and-Python
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX"libpypysite-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX"sharepypy"
  end

  # The Cellar location of distutils
  def distutils
    libexec"lib-python2.7distutils"
  end

  test do
    system bin"pypy", "-c", "print('Hello, world!')"
    system bin"pypy", "-c", "import time; time.clock()"
    system scripts_folder"pip", "list"
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