class TclTk < Formula
  desc "Tool Command Language"
  homepage "https:www.tcl-lang.org"
  url "https:downloads.sourceforge.netprojecttclTcl9.0.1tcl9.0.1-src.tar.gz"
  mirror "https:fossies.orglinuxmisctcl9.0.1-src.tar.gz"
  sha256 "a72b1607d7a399c75148c80fcdead88ed3371a29884181f200f2200cdee33bbc"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "aeeaea787bdc0aa434351c522ac051879d17181a0788a66293e96cf1e3cd2388"
    sha256 arm64_sonoma:  "13b0cd27c3f3c8e079e80313581d412ef03b88f1d5f8d03ec14ef05a0c384f6d"
    sha256 arm64_ventura: "abb40f075e37f7aa54369b4d9caab463198fa95028af4c65478b95744d89860c"
    sha256 sonoma:        "2e656bf381d6e37dd1f2d99c17408339741a409a84c4a5d2c9d89230829b87f3"
    sha256 ventura:       "650a6e8899dade18e17f3ae535a2191747bcc8cfc7950a0d0dd2506e804d9399"
    sha256 x86_64_linux:  "0621ca61e59e72e17e267a0bef5c133183752e45a71a759508084c4e2024b4b6"
  end

  depends_on "libtommath"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freetype" => :build
    depends_on "pkgconf" => :build
    depends_on "libx11"
    depends_on "libxext"
  end

  conflicts_with "page", because: "both install `page` binaries"
  conflicts_with "the_platinum_searcher", because: "both install `pt` binaries"

  resource "critcl" do
    url "https:github.comandreas-kupriescritclarchiverefstags3.3.1.tar.gz"
    sha256 "d970a06ae1cdee7854ca1bc571e8b5fe7189788dc5a806bce67e24bbadbe7ae2"

    livecheck do
      regex(^v?(\d+(?:\.\d+)+)$i)
    end
  end

  resource "tcllib" do
    url "https:downloads.sourceforge.netprojecttcllibtcllib2.0tcllib-2.0.tar.xz"
    sha256 "642c2c679c9017ab6fded03324e4ce9b5f4292473b62520e82aacebb63c0ce20"
  end

  # There is no tcltls release compatible with TCL 9 so using latest
  # check-in at https:core.tcl-lang.orgtcltlstimeline
  # Ref: https:core.tcl-lang.orgtcltlstktviewf5a0fe8ddf
  # Ref: https:sourceforge.netptclmailmantcl-corethreadeab3a8bf-b846-45ef-a80c-6bc94d6dfe91@elmicron.de
  resource "tcltls" do
    url "https:core.tcl-lang.orgtcltlstarballe03e54ee87tcltls-e03e54ee87.tar.gz"
    sha256 "db473afa98924c0a2b44ecacea35bb2609e6810de1df389ad55bb3688023f8d1"
  end

  resource "tk" do
    url "https:downloads.sourceforge.netprojecttclTcl9.0.1tk9.0.1-src.tar.gz"
    mirror "https:fossies.orglinuxmisctk9.0.1-src.tar.gz"
    sha256 "d6f01a4d598bfc6398be9584e1bab828c907b0758db4bbb351a1429106aec527"
  end

  # "https:downloads.sourceforge.netprojectincrtcl%5Bincr%20Tcl_Tk%5D-4-sourceitk%204.1.0itk4.1.0.tar.gz"
  # would cause `bad URI(is not URI?)` error on 1213 builds
  # Also need a newer release than available on SourceForce for TCL 9
  # so we use the GitHub mirror which is easier to access than Fossil
  resource "itk4" do
    url "https:github.comtcltkitkarchiverefstagsitk-4-2-3.tar.gz"
    version "4.2.3"
    sha256 "3eea66dfc57259d85ad741a01786b70ae4b3ae9774d27e24f7d0917c7451e94b"
  end

  def install
    odie "tk resource needs to be updated" if version != resource("tk").version

    # Remove bundled libraries. Some private headers are still needed
    ["compatzlib", "libtommath"].each do |dir|
      (buildpathdir).find do |path|
        rm(path) if path.file? && path.extname != ".h"
      end
    end

    args = %W[
      --prefix=#{prefix}
      --includedir=#{include}tcl-tk
      --mandir=#{man}
      --disable-zipfs
      --enable-man-suffix
      --enable-64bit
    ]

    ENV["TCL_PACKAGE_PATH"] = "#{HOMEBREW_PREFIX}lib"
    cd "unix" do
      system ".configure", *args, "--with-system-libtommath"
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      bin.install_symlink "tclsh#{version.to_f}" => "tclsh"
    end

    # Let tk finds our new tclsh
    ENV.prepend_path "PATH", bin

    resource("tk").stage do
      cd "unix" do
        args << "--enable-aqua=yes" if OS.mac?
        system ".configure", *args, "--without-x", "--with-tcl=#{lib}"
        system "make"
        system "make", "install"
        system "make", "install-private-headers"
        bin.install_symlink "wish#{version.to_f}" => "wish"
      end
    end

    resource("critcl").stage do
      system bin"tclsh", "build.tcl", "install"
    end

    resource("tcllib").stage do
      system ".configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
      system "make", "critcl"
      cp_r "modulestcllibc", "#{lib}"
      ln_s "#{lib}tcllibcmacosx-x86_64-clang", "#{lib}tcllibcmacosx-x86_64" if OS.mac?
    end

    resource("tcltls").stage do
      system ".configure", "--with-openssl-dir=#{Formula["openssl@3"].opt_prefix}",
                            "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make", "install"
    end

    resource("itk4").stage do
      itcl_dir = lib.glob("itcl*").last
      # Workaround to build non-release tarball by using TEA files from itcl
      odie "Update `itk4` build step!" if Pathname("tclconfig").exist?
      Pathname.pwd.install_symlink buildpath"pkgs#{itcl_dir.basename}tclconfig"

      args = %W[
        --prefix=#{prefix}
        --exec-prefix=#{prefix}
        --with-tcl=#{lib}
        --with-tclinclude=#{include}tcl-tk
        --with-tk=#{lib}
        --with-tkinclude=#{include}tcl-tk
        --with-itcl=#{itcl_dir}
      ]
      system ".configure", *args
      system "make"
      system "make", "install"
    end

    # Use the sqlite-analyzer formula instead
    # https:github.comHomebrewhomebrew-corepull82698
    rm bin"sqlite3_analyzer"
  end

  def caveats
    <<~EOS
      The sqlite3_analyzer binary is in the `sqlite-analyzer` formula.
    EOS
  end

  test do
    assert_match "#{HOMEBREW_PREFIX}lib", pipe_output("#{bin}tclsh", "puts $auto_path\n")
    assert_equal "honk", pipe_output("#{bin}tclsh", "puts honk\n").chomp

    # Fails with: no display name and no $DISPLAY environment variable
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    test_itk = <<~TCL
      # Check that Itcl and Itk load, and that we can define, instantiate,
      # and query the properties of a widget.


      # If anything errors, just exit
      catch {
          package require Itcl
          package require Itk

          # Define class
          itcl::class TestClass {
              inherit itk::Toplevel
              constructor {args} {
                  itk_component add bye {
                      button $itk_interior.bye -text "Bye"
                  }
                  eval itk_initialize $args
              }
          }

          # Create an instance
          set testobj [TestClass .#auto]

          # Check the widget has a bye component with text property "Bye"
          if {[[$testobj component bye] cget -text]=="Bye"} {
              puts "OK"
          }
      }
      exit
    TCL
    assert_equal "OK\n", pipe_output("#{bin}wish", test_itk), "Itk test failed"
  end
end