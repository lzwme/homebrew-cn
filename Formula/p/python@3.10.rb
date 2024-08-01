class PythonAT310 < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https:www.python.org"
  url "https:www.python.orgftppython3.10.14Python-3.10.14.tgz"
  sha256 "cefea32d3be89c02436711c95a45c7f8e880105514b78680c14fe76f5709a0f6"
  license "Python-2.0"
  revision 1

  livecheck do
    url "https:www.python.orgftppython"
    regex(%r{href=.*?v?(3\.10(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "1f26c727313e64239684fa9fb63cfd7029a11479936766ae7a14848baa98c944"
    sha256 arm64_ventura:  "65a306d08e3571ae8cbe910a3263a47b3e1168cc201bacde68d8fe1e06e47dea"
    sha256 arm64_monterey: "6b817155a2406df6bb6d8714f9a3ca89282fbf7014a4d425f4df2c6b90872008"
    sha256 sonoma:         "bcad91177c0b153e3f4b05eea38ead655816487577addf1ae4f776b04dc697ac"
    sha256 ventura:        "d58257241160b7267b40253c93a34aec100c96c79ef538b382504f455677ac14"
    sha256 monterey:       "d0c9d66682047e65ec60600e6d9af6086101c8ec244de396907b4128487becae"
    sha256 x86_64_linux:   "473a9bd7da4077db383e9a519fbbe1161a5bd219ec7342fc8035fe03f400c455"
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? only_if: :clt_installed

  depends_on "pkg-config" => :build
  depends_on "gdbm"
  depends_on "mpdecimal"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libnsl"
  end

  skip_clean "binpip3", "binpip-3.4", "binpip-3.5", "binpip-3.6", "binpip-3.7", "binpip-3.8", "binpip-3.9"
  skip_clean "bineasy_install3", "bineasy_install-3.4", "bineasy_install-3.5", "bineasy_install-3.6",
              "bineasy_install-3.7", "bineasy_install-3.8", "bineasy_install-3.9"

  # Always update to latest release
  resource "flit-core" do
    url "https:files.pythonhosted.orgpackagesc4e6c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80flit_core-3.9.0.tar.gz"
    sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  end

  resource "pip" do
    url "https:files.pythonhosted.orgpackages123dd899257cace386bebb7bdf8a872d5fe3b935cc6381c3ddb76d3e5d99890dpip-24.1.2.tar.gz"
    sha256 "e5458a0b89f2755e0ee8c0c77613fe5273e05f337907874d64f13171a898a7ff"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages65d810a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb8d6ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  # Modify default sysconfig to match the brew install layout.
  # Remove when a non-patching mechanism is added (https:bugs.python.orgissue43976).
  # We (ab)use osx_framework_library to exploit pip behaviour to allow --prefix to still work.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesa1618a5005d0b01d63b720321806820a03432f1apython3.10-sysconfig.diff"
    sha256 "51bc741a7f201bf7382067f5561a10968476c98d952e54a4f1931f17f1397ef8"
  end

  # Make bundled distutils look at preferred sysconfig scheme.
  # Remove with Python 3.12.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesa1618a5005d0b01d63b720321806820a03432f1apython3.10-distutils-scheme.diff"
    sha256 "d1a29b3c9ecf8aecd65e1e54efc42fb1422b2f5d05cba0c747178f4ef8a69683"
  end

  def lib_cellar
    on_macos do
      return frameworks"Python.frameworkVersions"version.major_minor"libpython#{version.major_minor}"
    end
    on_linux do
      return lib"python#{version.major_minor}"
    end
  end

  def site_packages_cellar
    lib_cellar"site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX"libpython#{version.major_minor}site-packages"
  end

  def python3
    bin"python#{version.major_minor}"
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    # Override the auto-detection in setup.py, which assumes a universal build.
    if OS.mac?
      ENV["PYTHON_DECIMAL_WITH_MACHINE"] = Hardware::CPU.arm? ? "uint128" : "x64"
    end

    # The --enable-optimization and --with-lto flags diverge from what upstream
    # python does for their macOS binary releases. They have chosen not to apply
    # these flags because they want one build that will work across many macOS
    # releases. Homebrew is not so constrained because the bottling
    # infrastructure specializes for each macOS major release.
    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --without-ensurepip
      --enable-loadable-sqlite-extensions
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-dbmliborder=gdbm:ndbm
      --enable-optimizations
      --with-system-expat
      --with-system-libmpdec
    ]

    # Python re-uses flags when building native modules.
    # Since we don't want native modules prioritizing the brew
    # include path, we move them to [C|LD]FLAGS_NODIST.
    # Note: Changing CPPFLAGS causes issues with dbm, so we
    # leave it as-is.
    cflags         = []
    cflags_nodist  = ["-I#{HOMEBREW_PREFIX}include"]
    ldflags        = []
    ldflags_nodist = ["-L#{HOMEBREW_PREFIX}lib", "-Wl,-rpath,#{HOMEBREW_PREFIX}lib"]
    cppflags       = ["-I#{HOMEBREW_PREFIX}include"]

    if OS.mac?
      # Enabling LTO on Linux makes libpython3.*.a unusable for anyone whose GCC
      # install does not match the one in CI _exactly_ (major and minor version).
      # https:github.comorgsHomebrewdiscussions3734
      args << "--with-lto"
      args << "--enable-framework=#{frameworks}"
      args << "--with-dtrace"

      if MacOS.sdk_path_if_needed
        # Help Python's build system (setuptoolspip) to build things on SDK-based systems
        # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
        cflags  << "-isysroot #{MacOS.sdk_path}"
        ldflags << "-isysroot #{MacOS.sdk_path}"
      end
      # Avoid linking to libgcc https:mail.python.orgpipermailpython-dev2012-February116205.html
      args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    else
      args << "--enable-shared"
    end

    # Resolve HOMEBREW_PREFIX in our sysconfig modification.
    inreplace "Libsysconfig.py", "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # Disable _tkinter - this is built in a separate formula python-tk
    inreplace "setup.py", "DISABLED_MODULE_LIST = []", "DISABLED_MODULE_LIST = ['_tkinter']"

    # We want our readline! This is just to outsmart the detection code,
    # superenv makes cc always find includeslibs!
    inreplace "setup.py",
      do_readline = self.compiler.find_library_file\(self.lib_dirs,\s*readline_lib\),
      "do_readline = '#{Formula["readline"].opt_libshared_library("libhistory")}'"

    inreplace "setup.py" do |s|
      s.gsub! "sqlite_setup_debug = False", "sqlite_setup_debug = True"
      s.gsub! "for d_ in self.inc_dirs + sqlite_inc_paths:",
              "for d_ in ['#{Formula["sqlite"].opt_include}']:"
    end

    if OS.linux?
      # Python's configure adds the system ncurses include entry to CPPFLAGS
      # when doing curses header check. The check may fail when there exists
      # a 32-bit system ncurses (conflicts with the brewed 64-bit one).
      # See https:github.comHomebrewlinuxbrew-corepull22307#issuecomment-781896552
      # We want our ncurses! Override system ncurses includes!
      inreplace "configure", 'CPPFLAGS="$CPPFLAGS -Iusrincludencursesw"',
                             "CPPFLAGS=\"$CPPFLAGS -I#{Formula["ncurses"].opt_include}\""
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a usrlocallib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace ".Libctypesmacholibdyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
              "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}lib', '#{Formula["openssl@3"].opt_lib}',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}Frameworks',"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "CFLAGS_NODIST=#{cflags_nodist.join(" ")}" unless cflags_nodist.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "LDFLAGS_NODIST=#{ldflags_nodist.join(" ")}" unless ldflags_nodist.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    system ".configure", *args
    system "make"

    ENV.deparallelize do
      # The `altinstall` target prevents the installation of files with only Python's major
      # version in its name. This allows us to link multiple versioned Python formulae.
      #   https:github.compythoncpython#installing-multiple-versions
      #
      # Tell Python not to install into Applications (default for framework builds)
      system "make", "altinstall", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}" if OS.mac?
    end

    if OS.mac?
      # Any .app get a " 3" attached, so it does not conflict with python 2.x.
      prefix.glob("*.app") { |app| mv app, app.to_s.sub(\.app$, " 3.app") }

      pc_dir = frameworks"Python.frameworkVersions"version.major_minor"libpkgconfig"
      # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
      (lib"pkgconfig").install_symlink pc_dir.children

      # Prevent third-party packages from building against fragile Cellar paths
      bad_cellar_path_files = [
        lib_cellar"_sysconfigdata__darwin_darwin.py",
        lib_cellar"config-#{version.major_minor}-darwinMakefile",
        pc_dir"python-#{version.major_minor}.pc",
        pc_dir"python-#{version.major_minor}-embed.pc",
      ]
      inreplace bad_cellar_path_files, prefix, opt_prefix

      # Help third-party packages find the Python framework
      inreplace lib_cellar"config-#{version.major_minor}-darwinMakefile",
                ^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*),
                "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

      # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
      (lib"pkgconfig").install_symlink pc_dir.children

      # Fix for https:github.comHomebrewhomebrew-coreissues21212
      inreplace lib_cellar"_sysconfigdata__darwin_darwin.py",
                %r{('LINKFORSHARED': .*?)'(Python.frameworkVersions3.\d+Python)'}m,
                "\\1'#{opt_prefix}Frameworks\\2'"

      # Remove symlinks that conflict with the main Python formula.
      rm %w[Headers Python Resources VersionsCurrent].map { |subdir| frameworks"Python.framework"subdir }
    else
      # Prevent third-party packages from building against fragile Cellar paths
      inreplace Dir[lib_cellar"**_sysconfigdata_*linux_x86_64-*.py",
                    lib_cellar"config*Makefile",
                    bin"python#{version.major_minor}-config",
                    lib"pkgconfigpython-3*.pc"],
                prefix, opt_prefix

      inreplace bin"python#{version.major_minor}-config",
                'prefix_real=$(installed_prefix "$0")',
                "prefix_real=#{opt_prefix}"

      # Remove symlinks that conflict with the main Python formula.
      rm lib"libpython3.so"
    end

    # Remove the site-packages that Python created in its Cellar.
    rm_r(site_packages_cellar)

    # Prepare a wheel of wheel to install later.
    common_pip_args = %w[
      -v
      --no-deps
      --no-binary :all:
      --no-index
      --no-build-isolation
    ]
    whl_build = buildpath"whl_build"
    system python3, "-m", "venv", whl_build
    resource("flit-core").stage do
      system whl_build"binpip3", "install", *common_pip_args, "."
    end
    resource("wheel").stage do
      system whl_build"binpip3", "install", *common_pip_args, "."
      system whl_build"binpip3", "wheel", *common_pip_args,
                                            "--wheel-dir=#{libexec}",
                                            "."
    end

    # Replace bundled setuptoolspip with our own.
    rm lib_cellar.glob("ensurepip_bundled{setuptools,pip}-*.whl")
    %w[setuptools pip].each do |r|
      resource(r).stage do
        system whl_build"binpip3", "wheel", *common_pip_args,
                                              "--wheel-dir=#{lib_cellar}ensurepip_bundled",
                                              "."
      end
    end

    # Patch ensurepip to bootstrap our updated versions of setuptoolspip
    inreplace lib_cellar"ensurepip__init__.py" do |s|
      s.gsub!(_SETUPTOOLS_VERSION = .*, "_SETUPTOOLS_VERSION = \"#{resource("setuptools").version}\"")
      s.gsub!(_PIP_VERSION = .*, "_PIP_VERSION = \"#{resource("pip").version}\"")
    end

    # Write out sitecustomize.py
    (lib_cellar"sitecustomize.py").atomic_write(sitecustomize)

    # Install unversioned and major-versioned symlinks in libexecbin.
    {
      "idle"           => "idle#{version.major_minor}",
      "idle3"          => "idle#{version.major_minor}",
      "pydoc"          => "pydoc#{version.major_minor}",
      "pydoc3"         => "pydoc#{version.major_minor}",
      "python"         => "python#{version.major_minor}",
      "python3"        => "python#{version.major_minor}",
      "python-config"  => "python#{version.major_minor}-config",
      "python3-config" => "python#{version.major_minor}-config",
    }.each do |short_name, long_name|
      (libexec"bin").install_symlink (binlong_name).realpath => short_name
    end
  end

  def post_install
    ENV.delete "PYTHONPATH"

    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in HOMEBREW_PREFIXlibpython#{version.major_minor}site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Remove old sitecustomize.py. Now stored in the cellar.
    rm_r(Dir["#{site_packages}sitecustomize.py[co]"])

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_r(Dir["#{site_packages}setuptools[-_.][0-9]*", "#{site_packages}setuptools"])
    rm_r(Dir["#{site_packages}distribute[-_.][0-9]*", "#{site_packages}distribute"])
    rm_r(Dir["#{site_packages}pip[-_.][0-9]*", "#{site_packages}pip"])
    rm_r(Dir["#{site_packages}wheel[-_.][0-9]*", "#{site_packages}wheel"])

    system python3, "-Im", "ensurepip"

    # Install desired versions of setuptools, pip, wheel using the version of
    # pip bootstrapped by ensurepip.
    # Note that while we replaced the ensurepip wheels, there's no guarantee
    # ensurepip actually used them, since other existing installations could
    # have been picked up (and we can't pass --ignore-installed).
    bundled = lib_cellar"ensurepip_bundled"
    system python3, "-Im", "pip", "install", "-v",
           "--no-deps",
           "--no-index",
           "--upgrade",
           "--isolated",
           "--target=#{site_packages}",
           bundled"setuptools-#{resource("setuptools").version}-py3-none-any.whl",
           bundled"pip-#{resource("pip").version}-py3-none-any.whl",
           libexec"wheel-#{resource("wheel").version}-py3-none-any.whl"

    # pip install with --target flag will just place the bin folder into the
    # target, so move its contents into the appropriate location
    mv (site_packages"bin").children, bin
    rmdir site_packages"bin"

    rm_r(bin.glob("pip{,3}"))
    mv bin"wheel", bin"wheel#{version.major_minor}"

    # Install unversioned and major-versioned symlinks in libexecbin.
    {
      "pip"    => "pip#{version.major_minor}",
      "pip3"   => "pip#{version.major_minor}",
      "wheel"  => "wheel#{version.major_minor}",
      "wheel3" => "wheel#{version.major_minor}",
    }.each do |short_name, long_name|
      (libexec"bin").install_symlink (binlong_name).realpath => short_name
    end

    # post_install happens after link
    %W[wheel#{version.major_minor} pip#{version.major_minor}].each do |e|
      (HOMEBREW_PREFIX"bin").install_symlink bine
    end
  end

  def sitecustomize
    <<~EOS
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https:docs.brew.shHomebrew-and-Python>
      import re
      import os
      import site
      import sys
      if sys.version_info[:2] != (#{version.major}, #{version.minor}):
          # This can only happen if the user has set the PYTHONPATH to a mismatching site-packages directory.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit(f'Your PYTHONPATH points to a site-packages dir for Python #{version.major_minor} '
               f'but you are running Python {sys.version_info[0]}.{sys.version_info[1]}!\\n'
               f'     PYTHONPATH is currently: "{os.environ["PYTHONPATH"]}"\\n'
               f'     You should `unset PYTHONPATH` to fix this.')
      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle Library site-packages to the end of sys.path
          library_site = 'LibraryPython#{version.major_minor}site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)
          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}[0-9\\._abrc]+FrameworksPython\\.frameworkVersions#{version.major_minor}libpython#{version.major_minor}site-packages')
          sys.path = [long_prefix.sub('#{site_packages}', p) for p in sys.path]
          # Set the sys.executable to use the opt_prefix. Only do this if PYTHONEXECUTABLE is not
          # explicitly set and we are not in a virtualenv:
          if 'PYTHONEXECUTABLE' not in os.environ and sys.prefix == sys.base_prefix:
              sys.executable = sys._base_executable = '#{opt_bin}python#{version.major_minor}'
      if 'PYTHONHOME' not in os.environ:
          cellar_prefix = re.compile(r'#{rack}[0-9\\._abrc]+')
          if os.path.realpath(sys.base_prefix).startswith('#{rack}'):
              new_prefix = cellar_prefix.sub('#{opt_prefix}', sys.base_prefix)
              if sys.prefix == sys.base_prefix:
                  site.PREFIXES[:] = [new_prefix if x == sys.prefix else x for x in site.PREFIXES]
                  sys.prefix = new_prefix
              sys.base_prefix = new_prefix
          if os.path.realpath(sys.base_exec_prefix).startswith('#{rack}'):
              new_exec_prefix = cellar_prefix.sub('#{opt_prefix}', sys.base_exec_prefix)
              if sys.exec_prefix == sys.base_exec_prefix:
                  site.PREFIXES[:] = [new_exec_prefix if x == sys.exec_prefix else x for x in site.PREFIXES]
                  sys.exec_prefix = new_exec_prefix
              sys.base_exec_prefix = new_exec_prefix
      # Check for and add the python-tk prefix.
      tkinter_prefix = "#{HOMEBREW_PREFIX}optpython-tk@#{version.major_minor}libexec"
      if os.path.isdir(tkinter_prefix):
          sys.path.append(tkinter_prefix)
    EOS
  end

  def caveats
    <<~EOS
      Python has been installed as
        #{HOMEBREW_PREFIX}binpython#{version.major_minor}

      Unversioned and major-versioned symlinks `python`, `python3`, `python-config`, `python3-config`, `pip`, `pip3`, etc. pointing to
      `python#{version.major_minor}`, `python#{version.major_minor}-config`, `pip#{version.major_minor}` etc., respectively, have been installed into
        #{opt_libexec}bin

      You can install Python packages with
        pip#{version.major_minor} install <package>
      They will install into the site-package directory
        #{HOMEBREW_PREFIX}libpython#{version.major_minor}site-packages

      tkinter is no longer included with this formula, but it is available separately:
        brew install python-tk@#{version.major_minor}

      If you do not need a specific version of Python, and always want Homebrew's `python3` in your PATH:
        brew install python3

      See: https:docs.brew.shHomebrew-and-Python
    EOS
  end

  test do
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system python3, "-c", "import sqlite3"

    # check to see if we can create a venv
    system python3, "-m", "venv", testpath"myvenv"

    # Check if some other modules import. Then the linked libs are working.
    system python3, "-c", "import _ctypes"
    system python3, "-c", "import _decimal"
    system python3, "-c", "import _gdbm"
    system python3, "-c", "import pyexpat"
    system python3, "-c", "import zlib"

    # tkinter is provided in a separate formula
    assert_match "ModuleNotFoundError: No module named '_tkinter'",
                 shell_output("#{python3} -Sc 'import tkinter' 2>&1", 1)

    # Verify that the selected DBM interface works
    (testpath"dbm_test.py").write <<~EOS
      import dbm

      with dbm.ndbm.open("test", "c") as db:
          db[b"foo \\xbd"] = b"bar \\xbd"
      with dbm.ndbm.open("test", "r") as db:
          assert list(db.keys()) == [b"foo \\xbd"]
          assert b"foo \\xbd" in db
          assert db[b"foo \\xbd"] == b"bar \\xbd"
    EOS
    system python3, "dbm_test.py"

    system bin"pip#{version.major_minor}", "list", "--format=columns"
  end
end