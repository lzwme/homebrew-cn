class PythonFreethreading < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https:www.python.org"
  url "https:www.python.orgftppython3.13.0Python-3.13.0.tgz"
  sha256 "12445c7b3db3126c41190bfdc1c8239c39c719404e844babbd015a1bc3fafcd4"
  license "Python-2.0"

  livecheck do
    formula "python"
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "98c43c254a600fcb8c1701369bc501db0fa4df72a2ad20d7e22cdc55e085fc2d"
    sha256 arm64_sonoma:  "f43cbd1d65a4dee79c5b040903c3755372d408073181d01cee47a52f453774b5"
    sha256 arm64_ventura: "5e1dfec49650c6c31cad7e38e2a198282b2f928494952db25ed47b016bc8c8ed"
    sha256 sonoma:        "faaeaaf1ae388ae484ad3fba8cb7a2595954605511f9b505efc4b8baf2d93a00"
    sha256 ventura:       "74c1f457660802b6f76250908167f448d6c951c6ccce345778cb92d69b5c55f3"
    sha256 x86_64_linux:  "7edd046e94be530008b8aa7cf8af55772ec95eb31f2e00fbfd079c758c9b7bf5"
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? only_if: :clt_installed

  depends_on "pkg-config" => :build
  depends_on "mpdecimal"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "xz"

  # not actually used, we just want this installed to ensure there are no conflicts.
  uses_from_macos "python" => :test
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
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb7a095e9e962c5fd9da11c1e28aa4c0d8210ab277b1ada951d2aee336b505813wheel-0.44.0.tar.gz"
    sha256 "a29c3f2817e95ab89aa4660681ad547c0e9547f20e75b0562fe7723c9a2a9d49"
  end

  # Modify default sysconfig to match the brew install layout.
  # Remove when a non-patching mechanism is added (https:bugs.python.orgissue43976).
  # We (ab)use osx_framework_library to exploit pip behaviour to allow --prefix to still work.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches22f07354b9778579dd3297bbce0ed3d3244dd982python3.13-sysconfig.diff"
    sha256 "9f2eae1d08720b06ac3d9ef1999c09388b9db39dfb52687fc261ff820bff20c3"
  end

  def lib_cellar
    on_macos do
      return frameworks"PythonT.frameworkVersions"version.major_minor"libpython#{version.major_minor}t"
    end
    on_linux do
      return lib"python#{version.major_minor}t"
    end
  end

  def site_packages_cellar
    lib_cellar"site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX"libpython#{version.major_minor}tsite-packages"
  end

  def python3
    bin"python#{version.major_minor}t"
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
      --disable-gil
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
      # install does not match the one in CI _exactly_ (major and minor version).
      # https:github.comorgsHomebrewdiscussions3734
      args << "--with-lto"
      args << "--enable-framework=#{frameworks}"
      args << "--with-framework-name=PythonT"
      args << "--with-dtrace"
      args << "--with-dbmliborder=ndbm"

      # Avoid linking to libgcc https:mail.python.orgpipermailpython-dev2012-February116205.html
      args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    else
      args << "--enable-shared"
      args << "--with-dbmliborder=bdb"
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

      pc_dir = lib_cellar.parent"pkgconfig"

      # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
      (lib"pkgconfig").install_symlink pc_dir.glob("*#{version.major_minor}t*")

      # Prevent third-party packages from building against fragile Cellar paths
      bad_cellar_path_files = [
        lib_cellar"_sysconfigdata_t_darwin_darwin.py",
        lib_cellar"config-#{version.major_minor}t-darwinMakefile",
        pc_dir"python-#{version.major_minor}t.pc",
        pc_dir"python-#{version.major_minor}t-embed.pc",
      ]
      inreplace bad_cellar_path_files, prefix, opt_prefix

      # Help third-party packages find the Python framework
      inreplace lib_cellar"config-#{version.major_minor}t-darwinMakefile",
                ^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*),
                "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

      # Fix for https:github.comHomebrewhomebrew-coreissues21212
      inreplace lib_cellar"_sysconfigdata_t_darwin_darwin.py",
                %r{('LINKFORSHARED': .*?) (PythonT.frameworkVersions3.\d+PythonT)'}m,
                "\\1 #{opt_prefix}Frameworks\\2'"

    else
      # Prevent third-party packages from building against fragile Cellar paths
      inreplace Dir[lib_cellar"**_sysconfigdata_t_*linux_x86_64-*.py",
                    lib_cellar"config*Makefile",
                    bin"python#{version.major_minor}t-config",
                    lib"pkgconfigpython-3*.pc"],
                prefix, opt_prefix

      inreplace bin"python#{version.major_minor}t-config",
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

    # Rename idle, pydoc to t variants
    mv bin"idle#{version.major_minor}", bin"idle#{version.major_minor}t"
    mv bin"pydoc#{version.major_minor}", bin"pydoc#{version.major_minor}t"

    # Remove files that conflict with the main python3 formula
    [bin, lib, lib"pkgconfig", include].each do |directory|
      (directory.glob("*python*") - directory.glob("*#{version.major_minor}t*")).map(&:unlink)
    end
    rm_r share
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
    mv bin"wheel", bin"wheel#{version.major_minor}t"
    mv bin"pip#{version.major_minor}", bin"pip#{version.major_minor}t"

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

         #{python3.basename} -m venv pathtovenv
         source pathtovenvbinactivate
         #{python3.basename} -m pip install xyz

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
          library_site = 'LibraryPython#{version.major_minor}tsite-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)
          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}[0-9\\._abrc]+FrameworksPythonT\\.frameworkVersions#{version.major_minor}libpython#{version.major_minor}tsite-packages')
          sys.path = [long_prefix.sub('#{site_packages}', p) for p in sys.path]
          # Set the sys.executable to use the opt_prefix. Only do this if PYTHONEXECUTABLE is not
          # explicitly set and we are not in a virtualenv:
          if 'PYTHONEXECUTABLE' not in os.environ and sys.prefix == sys.base_prefix:
              sys.executable = sys._base_executable = '#{opt_bin}python#{version.major_minor}t'
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
          split_prefix = f"#{HOMEBREW_PREFIX}optpython-{split_module}@#{version.major_minor}tlibexec"
          if os.path.isdir(split_prefix):
              sys.path.append(split_prefix)
    EOS
  end

  def caveats
    <<~EOS
      Python has been installed as
        #{HOMEBREW_PREFIX}bin#{python3.basename}

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

    system bin"pip#{version.major_minor}t", "list", "--format=columns"

    # Verify our sysconfig patches
    sysconfig_path = "import sysconfig; print(sysconfig.get_paths(\"osx_framework_library\")[\"data\"])"
    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{python3} -c '#{sysconfig_path}'").strip
    linkforshared_var = "import sysconfig; print(sysconfig.get_config_var(\"LINKFORSHARED\"))"
    assert_match opt_prefix.to_s, shell_output("#{python3} -c '#{linkforshared_var}'") if OS.mac?

    # Check our externally managed marker
    assert_match "If you wish to install a Python library",
                 shell_output("#{python3} -m pip install pip 2>&1", 1)
    assert_equal "False", shell_output("#{python3} -c 'import sys; print(sys._is_gil_enabled())'").chomp
  end
end