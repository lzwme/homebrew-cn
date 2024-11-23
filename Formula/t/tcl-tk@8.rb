class TclTkAT8 < Formula
  desc "Tool Command Language"
  homepage "https:www.tcl-lang.org"
  url "https:downloads.sourceforge.netprojecttclTcl8.6.15tcl8.6.15-src.tar.gz"
  sha256 "861e159753f2e2fbd6ec1484103715b0be56be3357522b858d3cbb5f893ffef1"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?(?:tcl|tk).?v?(8(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "b0014023f7ec4972cf80f05b10a73a53b55636edf9feae4be8e2a90591dda956"
    sha256 arm64_sonoma:  "64d42662917f5c9a20db0b6f38ad45c577228d6e86cfb780426df985ff547b11"
    sha256 arm64_ventura: "4eb35b49cee9db142bb0bc3a2bed1fb97b8a415d8b490a4c74fd2cab4275c47f"
    sha256 sonoma:        "40a34778d277bc8630b796d7ebf16e26d9dcc59d1bd390ed732b61498719279c"
    sha256 ventura:       "befba542838d1bf3a5d9a8439f2b76586e92c9e034f0043aebd062a7bb3c6ccf"
    sha256 x86_64_linux:  "1ef83a31cf19fa26dc54ad9d79c581fa1d03aee953b791c35a92a5079c10e665"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freetype" => :build
    depends_on "pkgconf" => :build
    depends_on "libx11"
    depends_on "libxext"
  end

  resource "critcl" do
    url "https:github.comandreas-kupriescritclarchiverefstags3.3.1.tar.gz"
    sha256 "d970a06ae1cdee7854ca1bc571e8b5fe7189788dc5a806bce67e24bbadbe7ae2"
  end

  resource "tcllib" do
    url "https:downloads.sourceforge.netprojecttcllibtcllib2.0tcllib-2.0.tar.xz"
    sha256 "642c2c679c9017ab6fded03324e4ce9b5f4292473b62520e82aacebb63c0ce20"
  end

  resource "tcltls" do
    url "https:core.tcl-lang.orgtcltlsuvtcltls-1.7.22.tar.gz"
    sha256 "e84e2b7a275ec82c4aaa9d1b1f9786dbe4358c815e917539ffe7f667ff4bc3b4"
  end

  resource "tk" do
    url "https:downloads.sourceforge.netprojecttclTcl8.6.15tk8.6.15-src.tar.gz"
    sha256 "550969f35379f952b3020f3ab7b9dd5bfd11c1ef7c9b7c6a75f5c49aca793fec"
  end

  # "https:downloads.sourceforge.netprojectincrtcl%5Bincr%20Tcl_Tk%5D-4-sourceitk%204.1.0itk4.1.0.tar.gz"
  # would cause `bad URI(is not URI?)` error on 1213 builds
  resource "itk4" do
    url "https:deb.debian.orgdebianpoolmainiitk4itk4_4.1.0.orig.tar.gz"
    mirror "https:src.fedoraproject.orglookasideextrasitkitk4.1.0.tar.gzsha5121deed09daf66ae1d0cc88550be13814edff650f3ef2ecb5ae8d28daf92e37550b0e46921eb161da8ccc3886aaf62a4a3087df0f13610839b7c2d6f4b39c9f07eitk4.1.0.tar.gz"
    sha256 "da646199222efdc4d8c99593863c8d287442ea5a8687f95460d6e9e72431c9c7"
  end

  def install
    odie "tk resource needs to be updated" if version != resource("tk").version

    # Remove bundled zlib
    rm_r("compatzlib")

    args = %W[
      --prefix=#{prefix}
      --includedir=#{include}tcl-tk
      --mandir=#{man}
      --enable-man-suffix
      --enable-threads
      --enable-64bit
    ]

    ENV["TCL_PACKAGE_PATH"] = "#{HOMEBREW_PREFIX}lib"
    cd "unix" do
      system ".configure", *args
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
      system ".configure", "--with-ssl=openssl",
                            "--with-openssl-dir=#{Formula["openssl@3"].opt_prefix}",
                            "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make", "install"
    end

    resource("itk4").stage do
      itcl_dir = lib.glob("itcl*").last
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