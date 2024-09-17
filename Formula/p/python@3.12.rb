class PythonAT312 < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https:www.python.org"
  url "https:www.python.orgftppython3.12.6Python-3.12.6.tgz"
  sha256 "85a4c1be906d20e5c5a69f2466b00da769c221d6a684acfd3a514dbf5bf10a66"
  license "Python-2.0"

  livecheck do
    url "https:www.python.orgftppython"
    regex(%r{href=.*?v?(3\.12(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia:  "27e2aeca98ebad5afc7a2937f9571826ee3c8bd724306f7d85de5e47d9dce571"
    sha256 arm64_sonoma:   "00871488a4207f0265eab8e339146f63874e7454487169e819a1e4a5bd13a62b"
    sha256 arm64_ventura:  "2d4c6e84be927a29d116e1f2bd5e09e0b00dab2141d58377f255949d363b5892"
    sha256 arm64_monterey: "d9c70d61697dc082c561f47bf8bde3cf2dcdb1070f0705a65d9acd67ff3acf65"
    sha256 sequoia:        "723e1c33533e84a6762051f25180b64f36942f47f988bccd9b1956c1852d39c4"
    sha256 sonoma:         "ac351a070751905ceb68a1f570601ff0b712613830e2b6c14063c7243b2bb259"
    sha256 ventura:        "8abd20343a066df8d2be5c81c4a2a968838003cf40da8838c052255747d704eb"
    sha256 monterey:       "594da1f2f1785d54cc85b646fe0520813071fc74fd7d610f4ecad4b55ce842c0"
    sha256 x86_64_linux:   "e0c5b329ce19642fa0d54abf71fb33eae36cee265ff03479fe1ae929918a1329"
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? only_if: :clt_installed

  depends_on "pkg-config" => :build
  depends_on "mpdecimal"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libedit"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  on_linux do
    depends_on "berkeley-db@5"
    depends_on "libnsl"
    depends_on "libtirpc"
  end

  link_overwrite "bin2to3"
  link_overwrite "binidle3"
  link_overwrite "binpip3"
  link_overwrite "binpydoc3"
  link_overwrite "binpython3"
  link_overwrite "binpython3-config"
  link_overwrite "binwheel3"
  link_overwrite "sharemanman1python3.1"
  link_overwrite "liblibpython3.so"
  link_overwrite "libpkgconfigpython3.pc"
  link_overwrite "libpkgconfigpython3-embed.pc"
  link_overwrite "FrameworksPython.frameworkHeaders"
  link_overwrite "FrameworksPython.frameworkPython"
  link_overwrite "FrameworksPython.frameworkResources"
  link_overwrite "FrameworksPython.frameworkVersionsCurrent"

  # Always update to latest release
  resource "flit-core" do
    url "https:files.pythonhosted.orgpackagesc4e6c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80flit_core-3.9.0.tar.gz"
    sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  end

  resource "pip" do
    url "https:files.pythonhosted.orgpackages4d87fb90046e096a03aeab235e139436b3fe804cdd447ed2093b0d70eba3f7f8pip-24.2.tar.gz"
    sha256 "5b5e490b5e9cb275c879595064adce9ebd31b854e3e803740b72f9ccf34a45b8"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages3e2cf0a538a2f91ce633a78daaeb34cbfb93a54bd2132a6de1f6cec028eee6efsetuptools-74.1.2.tar.gz"
    sha256 "95b40ed940a1c67eb70fc099094bd6e99c6ee7c23aa2306f4d2697ba7916f9c6"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb7a095e9e962c5fd9da11c1e28aa4c0d8210ab277b1ada951d2aee336b505813wheel-0.44.0.tar.gz"
    sha256 "a29c3f2817e95ab89aa4660681ad547c0e9547f20e75b0562fe7723c9a2a9d49"
  end

  # Modify default sysconfig to match the brew install layout.
  # Remove when a non-patching mechanism is added (https:bugs.python.orgissue43976).
  # We (ab)use osx_framework_library to exploit pip behaviour to allow --prefix to still work.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches6d2fba8de3159182025237d373a6f4f78b8bd203python3.11-sysconfig.diff"
    sha256 "8bfe417c815da4ca2c0a2457ce7ef81bc9dae310e20e4fb36235901ea4be1658"
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

    # Override the auto-detection of libmpdec, which assumes a universal build.
    # This is currently an inreplace due to https:github.compythoncpythonissues98557.
    if OS.mac?
      inreplace "configure", "libmpdec_machine=universal",
                "libmpdec_machine=#{ENV["PYTHON_DECIMAL_WITH_MACHINE"] = Hardware::CPU.arm? ? "uint128" : "x64"}"
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
      --enable-optimizations
      --with-system-expat
      --with-system-libmpdec
      --with-readline=editline
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
      if MacOS.sdk_path_if_needed
        # Help Python's build system (setuptoolspip) to build things on SDK-based systems
        # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
        cflags  << "-isysroot #{MacOS.sdk_path}"
        ldflags << "-isysroot #{MacOS.sdk_path}"
      end

      # Enabling LTO on Linux makes libpython3.*.a unusable for anyone whose GCC
      # install does not match the one in CI _exactly_ (major and minßor version).
      # https:github.comorgsHomebrewdiscussions3734
      args << "--with-lto"
      args << "--enable-framework=#{frameworks}"
      args << "--with-dtrace"
      args << "--with-dbmliborder=ndbm"

      # Avoid linking to libgcc https:mail.python.orgpipermailpython-dev2012-February116205.html
      args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    else
      args << "--enable-shared"
      args << "--with-dbmliborder=bdb"
    end

    # Resolve HOMEBREW_PREFIX in our sysconfig modification.
    inreplace "Libsysconfig.py", "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

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

    # Disabled modules - provided in separate formulae
    args += %w[
      py_cv_module__tkinter=disabled
    ]

    system ".configure", *args
    system "make"

    ENV.deparallelize do
      # Tell Python not to install into Applications (default for framework builds)
      system "make", "install", "PYTHONAPPSDIR=#{prefix}"
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
    %w[flit-core wheel setuptools].each do |r|
      resource(r).stage do
        system whl_build"binpip3", "install", *common_pip_args, "."
      end
    end
    resource("wheel").stage do
      system whl_build"binpip3", "wheel", *common_pip_args,
                                            "--wheel-dir=#{libexec}",
                                            "."
    end

    # Replace bundled pip with our own.
    rm lib_cellar.glob("ensurepip_bundledpip-*.whl")
    %w[pip].each do |r|
      resource(r).stage do
        system whl_build"binpip3", "wheel", *common_pip_args,
                                              "--wheel-dir=#{lib_cellar}ensurepip_bundled",
                                              "."
      end
    end

    # Patch ensurepip to bootstrap our updated version of pip
    inreplace lib_cellar"ensurepip__init__.py" do |s|
      s.gsub!(_PIP_VERSION = .*, "_PIP_VERSION = \"#{resource("pip").version}\"")
    end

    # Write out sitecustomize.py
    (lib_cellar"sitecustomize.py").atomic_write(sitecustomize)

    # Install unversioned symlinks in libexecbin.
    {
      "idle"          => "idle#{version.major_minor}",
      "pydoc"         => "pydoc#{version.major_minor}",
      "python"        => "python#{version.major_minor}",
      "python-config" => "python#{version.major_minor}-config",
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
    rm_r(Dir["#{site_packages}distribute[-_.][0-9]*", "#{site_packages}distribute"])
    rm_r(Dir["#{site_packages}pip[-_.][0-9]*", "#{site_packages}pip"])
    rm_r(Dir["#{site_packages}wheel[-_.][0-9]*", "#{site_packages}wheel"])

    (lib_cellar"EXTERNALLY-MANAGED").unlink if (lib_cellar"EXTERNALLY-MANAGED").exist?
    system python3, "-Im", "ensurepip"

    # Install desired versions of pip, wheel using the version of
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
           bundled"pip-#{resource("pip").version}-py3-none-any.whl",
           libexec"wheel-#{resource("wheel").version}-py3-none-any.whl"

    # pip install with --target flag will just place the bin folder into the
    # target, so move its contents into the appropriate location
    mv (site_packages"bin").children, bin
    rmdir site_packages"bin"

    rm_r(bin"pip")
    mv bin"wheel", bin"wheel#{version.major_minor}"
    bin.install_symlink "wheel#{version.major_minor}" => "wheel3"

    # Install unversioned symlinks in libexecbin.
    {
      "pip"   => "pip#{version.major_minor}",
      "wheel" => "wheel#{version.major_minor}",
    }.each do |short_name, long_name|
      (libexec"bin").install_symlink (binlong_name).realpath => short_name
    end

    # post_install happens after link
    %W[wheel3 pip3 wheel#{version.major_minor} pip#{version.major_minor}].each do |e|
      (HOMEBREW_PREFIX"bin").install_symlink bine
    end

    # Mark Homebrew python as externally managed: https:peps.python.orgpep-0668#marking-an-interpreter-as-using-an-external-package-manager
    # Placed after ensurepip since it invokes pip in isolated mode, meaning
    # we can't pass --break-system-packages.
    (lib_cellar"EXTERNALLY-MANAGED").write <<~EOS
      [externally-managed]
      Error=To install Python packages system-wide, try brew install
       xyz, where xyz is the package you are trying to
       install.

       If you wish to install a Python library that isn't in Homebrew,
       use a virtual environment:

         python3 -m venv pathtovenv
         source pathtovenvbinactivate
         python3 -m pip install xyz

       If you wish to install a Python application that isn't in Homebrew,
       it may be easiest to use 'pipx install xyz', which will manage a
       virtual environment for you. You can install pipx with

         brew install pipx

       You may restore the old behavior of pip by passing
       the '--break-system-packages' flag to pip, or by adding
       'break-system-packages = true' to your pip.conf file. The latter
       will permanently disable this error.

       If you disable this error, we STRONGLY recommend that you additionally
       pass the '--user' flag to pip, or set 'user = true' in your pip.conf
       file. Failure to do this can result in a broken Homebrew installation.

       Read more about this behavior here: <https:peps.python.orgpep-0668>
    EOS
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
      # Check for and add the prefix of split Python formulae.
      for split_module in ["tk", "gdbm"]:
          split_prefix = f"#{HOMEBREW_PREFIX}optpython-{split_module}@#{version.major_minor}libexec"
          if os.path.isdir(split_prefix):
              sys.path.append(split_prefix)
    EOS
  end

  def caveats
    <<~EOS
      Python has been installed as
        #{HOMEBREW_PREFIX}binpython3

      Unversioned symlinks `python`, `python-config`, `pip` etc. pointing to
      `python3`, `python3-config`, `pip3` etc., respectively, have been installed into
        #{opt_libexec}bin

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
    system python3, "-c", "import pyexpat"
    system python3, "-c", "import readline"
    system python3, "-c", "import zlib"

    # tkinter is provided in a separate formula
    assert_match "ModuleNotFoundError: No module named '_tkinter'",
                 shell_output("#{python3} -Sc 'import tkinter' 2>&1", 1)

    # gdbm is provided in a separate formula
    assert_match "ModuleNotFoundError: No module named '_gdbm'",
                 shell_output("#{python3} -Sc 'import _gdbm' 2>&1", 1)
    assert_match "ModuleNotFoundError: No module named '_gdbm'",
                 shell_output("#{python3} -Sc 'import dbm.gnu' 2>&1", 1)

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

    # Check our externally managed marker
    assert_match "If you wish to install a Python library",
                 shell_output("#{python3} -m pip install pip 2>&1", 1)
  end
end