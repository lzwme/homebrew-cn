class PythonAT37 < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.7.16/Python-3.7.16.tar.xz"
  sha256 "8338f0c2222d847e904c955369155dc1beeeed806e8d5ef04b00ef4787238bfd"
  license "Python-2.0"

  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.7(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 ventura:      "36df3753c31cd484baf76d0a5fd86fbf6a535f9471eea7da75ce9710213ddc84"
    sha256 monterey:     "6f5d5dbcb09c6a747c511fea853d971e91abe9b84892c2b435e4e113cfd1aacf"
    sha256 big_sur:      "53723ea42f0f296159b9af4b5f409f4a51cf13922fb05ec5f54ce0d105c41ab4"
    sha256 x86_64_linux: "86492ae50222d0908a2b27e07a9d06f01d58888cac2577366e62bb3f41c5c81e"
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? only_if: :clt_installed

  # https://devguide.python.org/versions/#versions
  disable! date: "2023-06-27", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "gdbm"
  depends_on "mpdecimal"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libnsl"
  end

  skip_clean "bin/pip3", "bin/pip-3.4", "bin/pip-3.5", "bin/pip-3.6", "bin/pip-3.7"
  skip_clean "bin/easy_install3", "bin/easy_install-3.4", "bin/easy_install-3.5",
             "bin/easy_install-3.6", "bin/easy_install-3.7"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/b6/21/cb9a8d0b2c8597c83fce8e9c02884bce3d4951e41e807fc35791c6b23d9a/setuptools-65.6.3.tar.gz"
    sha256 "a7620757bf984b58deaf32fc8a4577a9bbc0850cf92c20e1ce41c38c19e5fb75"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/a3/50/c4d2727b99052780aad92c7297465af5fe6eec2dbae490aa9763273ffdc1/pip-22.3.1.tar.gz"
    sha256 "65fd48317359f3af8e593943e6ae1506b66325085ea64b706a998c6e83eeaf38"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a2/b8/6a06ff0f13a00fc3c3e7d222a995526cbca26c1ad107691b6b1badbbabf1/wheel-0.38.4.tar.gz"
    sha256 "965f5259b566725405b05e7cf774052044b1ed30119b5d586b2703aafe8719ac"
  end

  # Patch for MACOSX_DEPLOYMENT_TARGET on Big Sur. Upstream currently does
  # not have plans to backport the fix to 3.7, so we're maintaining this patch
  # ourselves.
  # https://bugs.python.org/issue42504
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/c4bc563a8d008ebd0e8d927c043f6dd132d3ba89/python/big-sur-3.7.patch"
    sha256 "67c99bdf0bbe0a640d70747aad514cd74602e7c4715fd15f1f9863eef257735e"
  end

  # Link against libmpdec.so.3, update for mpdecimal.h symbol cleanup.
  patch do
    url "https://www.bytereef.org/contrib/decimal-3.7.diff"
    sha256 "aa9a3002420079a7d2c6033d80b49038d490984a9ddb3d1195bb48ca7fb4a1f0"
  end

  def lib_cellar
    on_macos do
      return frameworks/"Python.framework/Versions"/version.major_minor/"lib/python#{version.major_minor}"
    end
    on_linux do
      return lib/"python#{version.major_minor}"
    end
  end

  def site_packages_cellar
    lib_cellar/"site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python#{version.major_minor}/site-packages"
  end

  def python3
    bin/"python#{version.major_minor}"
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    # Override the auto-detection in setup.py, which assumes a universal build.
    ENV["PYTHON_DECIMAL_WITH_MACHINE"] = "x64" if OS.mac?

    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --enable-loadable-sqlite-extensions
      --without-ensurepip
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-system-libmpdec
    ]

    args << "--without-gcc" if ENV.compiler == :clang

    if OS.mac?
      args << "--enable-framework=#{frameworks}"
      args << "--with-dtrace"
    else
      args << "--enable-shared"
    end

    cflags   = []
    ldflags  = []
    cppflags = []

    if MacOS.sdk_path_if_needed
      # Help Python's build system (setuptools/pip) to build things on SDK-based systems
      # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
      cflags  << "-isysroot #{MacOS.sdk_path}"
      ldflags << "-isysroot #{MacOS.sdk_path}"
      # For the Xlib.h, Python needs this header dir with the system Tk
      # Yep, this needs the absolute path where zlib needed a path relative
      # to the SDK.
      cflags << "-isystem #{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
    end
    # Avoid linking to libgcc https://mail.python.org/pipermail/python-dev/2012-February/116205.html
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    # Python's setup.py parses CPPFLAGS and LDFLAGS to learn search
    # paths for the dependencies of the compiled extension modules.
    # See Linuxbrew/linuxbrew#420, Linuxbrew/linuxbrew#460, and Linuxbrew/linuxbrew#875
    if OS.linux?
      cppflags << ENV.cppflags << " -I#{HOMEBREW_PREFIX}/include"
      ldflags << ENV.ldflags << " -L#{HOMEBREW_PREFIX}/lib"
    end

    # We want our readline! This is just to outsmart the detection code,
    # superenv makes cc always find includes/libs!
    inreplace "setup.py",
      "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
      "do_readline = '#{Formula["readline"].opt_lib/shared_library("libhistory")}'"

    inreplace "setup.py" do |s|
      s.gsub! "sqlite_setup_debug = False", "sqlite_setup_debug = True"
      s.gsub! "for d_ in inc_dirs + sqlite_inc_paths:",
              "for d_ in ['#{Formula["sqlite"].opt_include}']:"
    end

    if OS.linux?
      # Python's configure adds the system ncurses include entry to CPPFLAGS
      # when doing curses header check. The check may fail when there exists
      # a 32-bit system ncurses (conflicts with the brewed 64-bit one).
      # See https://github.com/Homebrew/linuxbrew-core/pull/22307#issuecomment-781896552
      # We want our ncurses! Override system ncurses includes!
      inreplace "configure", 'CPPFLAGS="$CPPFLAGS -I/usr/include/ncursesw"',
                             "CPPFLAGS=\"$CPPFLAGS -I#{Formula["ncurses"].opt_include}\""
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [", "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    system "./configure", *args
    system "make"

    ENV.deparallelize do
      # The `altinstall` target prevents the installation of files with only Python's major
      # version in its name. This allows us to link multiple versioned Python formulae.
      #   https://github.com/python/cpython#installing-multiple-versions
      #
      # Tell Python not to install into /Applications (default for framework builds)
      system "make", "altinstall", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}" if OS.mac?
    end

    # `brew` mishandles hardlinks, so replace with a symlink.
    (bin/"python#{version.major_minor}m").unlink # Hardlink to "python#{version.major_minor}"
    bin.install_symlink "python#{version.major_minor}" => "python#{version.major_minor}m"

    # Fix missing symlinks from `altinstall`.
    bin.install_symlink "python#{version.major_minor}m-config" => "python#{version.major_minor}-config"
    bin.install_symlink "pyvenv-#{version.major_minor}" => "pyvenv"

    if OS.mac?
      # Any .app get a " 3" attached, so it does not conflict with python 2.x.
      prefix.glob("*.app") { |app| mv app, app.to_s.sub(/\.app$/, " 3.app") }

      pc_dir = frameworks/"Python.framework/Versions"/version.major_minor/"lib/pkgconfig"
      # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
      (lib/"pkgconfig").install_symlink pc_dir.children

      # Prevent third-party packages from building against fragile Cellar paths
      bad_cellar_path_files = [
        lib_cellar/"_sysconfigdata_m_darwin_darwin.py",
        lib_cellar/"config-#{version.major_minor}m-darwin/Makefile",
        pc_dir/"python-#{version.major_minor}.pc",
      ]
      inreplace bad_cellar_path_files, prefix, opt_prefix

      # Help third-party packages find the Python framework
      inreplace lib_cellar/"config-#{version.major_minor}m-darwin/Makefile",
                /^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*)/,
                "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

      # Fix for https://github.com/Homebrew/homebrew-core/issues/21212
      inreplace lib_cellar/"_sysconfigdata_m_darwin_darwin.py",
                %r{('LINKFORSHARED': .*?)'(Python.framework/Versions/3.\d+/Python)'}m,
                "\\1'#{opt_prefix}/Frameworks/\\2'"

      # Remove symlinks that conflict with the main Python formula.
      rm %w[Headers Python Resources Versions/Current].map { |subdir| frameworks/"Python.framework"/subdir }
    else
      # Prevent third-party packages from building against fragile Cellar paths
      inreplace Dir[lib_cellar/"**/_sysconfigdata_m_linux_x86_64-*.py",
                    lib_cellar/"config*/Makefile",
                    lib/"pkgconfig/python-3.?.pc"],
                prefix, opt_prefix

      # Remove symlinks that conflict with the main Python formula.
      rm lib/"libpython3.so"
    end

    # Remove the site-packages that Python created in its Cellar.
    site_packages_cellar.rmtree

    %w[setuptools pip wheel].each do |r|
      (libexec/r).install resource(r)
    end

    # Remove wheel test data.
    # It's for people editing wheel and contains binaries which fail `brew linkage`.
    rm libexec/"wheel/tox.ini"
    rm_r libexec/"wheel/tests"

    # Install unversioned and major-versioned symlinks in libexec/bin.
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
      (libexec/"bin").install_symlink (bin/long_name).realpath => short_name
    end
  end

  def post_install
    ENV.delete "PYTHONPATH"

    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in HOMEBREW_PREFIX/lib/python#{version.major_minor}/site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Write our sitecustomize.py
    rm_rf site_packages.glob("sitecustomize.py[co]")
    (site_packages/"sitecustomize.py").atomic_write(sitecustomize)

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_rf Dir["#{site_packages}/setuptools*"]
    rm_rf Dir["#{site_packages}/distribute*"]
    rm_rf Dir["#{site_packages}/pip[-_.][0-9]*", "#{site_packages}/pip"]

    %w[setuptools pip wheel].each do |pkg|
      (libexec/pkg).cd do
        system python3, "-s", "setup.py", "--no-user-cfg", "install",
                        "--force", "--verbose", "--install-scripts=#{bin}",
                        "--install-lib=#{site_packages}",
                        "--single-version-externally-managed",
                        "--record=installed.txt"
      end
    end

    rm_rf [bin/"pip", bin/"pip3", bin/"easy_install"]
    mv bin/"wheel", bin/"wheel#{version.major_minor}"

    # Install unversioned symlinks in libexec/bin.
    {
      "pip"    => "pip#{version.major_minor}",
      "pip3"   => "pip#{version.major_minor}",
      "wheel"  => "wheel#{version.major_minor}",
      "wheel3" => "wheel#{version.major_minor}",
    }.each do |short_name, long_name|
      (libexec/"bin").install_symlink (bin/long_name).realpath => short_name
    end

    # post_install happens after link
    %W[wheel#{version.major_minor} pip#{version.major_minor}].each do |e|
      (HOMEBREW_PREFIX/"bin").install_symlink bin/e
    end

    # Help distutils find brewed stuff when building extensions
    include_dirs = [HOMEBREW_PREFIX/"include", Formula["openssl@1.1"].opt_include,
                    Formula["sqlite"].opt_include]
    library_dirs = [HOMEBREW_PREFIX/"lib", Formula["openssl@1.1"].opt_lib,
                    Formula["sqlite"].opt_lib]

    cfg = lib_cellar/"distutils/distutils.cfg"

    cfg.atomic_write <<~EOS
      [install]
      prefix=#{HOMEBREW_PREFIX}

      [build_ext]
      include_dirs=#{include_dirs.join ":"}
      library_dirs=#{library_dirs.join ":"}
    EOS
  end

  def sitecustomize
    <<~EOS
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://docs.brew.sh/Homebrew-and-Python>
      import re
      import os
      import sys
      if sys.version_info[0] != 3:
          # This can only happen if the user has set the PYTHONPATH for 3.x and run Python 2.x or vice versa.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit(f'Your PYTHONPATH points to a site-packages dir for Python 3.x '
               f'but you are running Python {sys.version_info[0]}.x!\\n'
               f'     PYTHONPATH is currently: "{os.environ["PYTHONPATH"]}"\\n'
               f'     You should `unset PYTHONPATH` to fix this.')
      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path
          library_site = '/Library/Python/#{version.major_minor}/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)
          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/[0-9._abrc]+/Frameworks/Python.framework/Versions/#{version.major_minor}/lib/python#{version.major_minor}/site-packages')
          sys.path = [long_prefix.sub('#{site_packages}', p) for p in sys.path]
          # Set the sys.executable to use the opt_prefix. Only do this if PYTHONEXECUTABLE is not
          # explicitly set and we are not in a virtualenv:
          if 'PYTHONEXECUTABLE' not in os.environ and sys.prefix == sys.base_prefix:
              sys.executable = '#{opt_bin}/python#{version.major_minor}'
    EOS
  end

  def caveats
    <<~EOS
      Python has been installed as
        #{HOMEBREW_PREFIX}/bin/python#{version.major_minor}

      Unversioned and major-versioned symlinks `python`, `python3`, `python-config`, `python3-config`, `pip`, `pip3`, etc. pointing to
      `python#{version.major_minor}`, `python#{version.major_minor}-config`, `pip#{version.major_minor}` etc., respectively, have been installed into
        #{opt_libexec}/bin

      You can install Python packages with
        pip#{version.major_minor} install <package>
      They will install into the site-package directory
        #{HOMEBREW_PREFIX}/lib/python#{version.major_minor}/site-packages

      If you do not need a specific version of Python, and always want Homebrew's `python3` in your PATH:
        brew install python3

      See: https://docs.brew.sh/Homebrew-and-Python
    EOS
  end

  test do
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system python3, "-c", "import sqlite3"
    # Check if some other modules import. Then the linked libs are working.
    system python3, "-c", "import tkinter; root = tkinter.Tk()" if OS.mac? && (MacOS.full_version < "11.1")
    system python3, "-c", "import _decimal"
    system python3, "-c", "import _gdbm"
    system python3, "-c", "import zlib"
    system bin/"pip#{version.major_minor}", "list", "--format=columns"
  end
end