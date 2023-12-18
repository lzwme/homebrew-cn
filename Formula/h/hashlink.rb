class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https:hashlink.haxe.org"
  url "https:github.comHaxeFoundationhashlinkarchiverefstags1.13.tar.gz"
  sha256 "696aef6871771e5e12c617df79187d1761e79bcfe3927531e99f665a8002956f"
  license "MIT"
  head "https:github.comHaxeFoundationhashlink.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 sonoma:       "b8a75d4ef538ef2024dc205c971a3f27bfacbaaeacb26b55c7b5869267c44c3e"
    sha256 cellar: :any,                 ventura:      "f0778094f28f41cad49813acef8c2bd12a1e6de08704ec50028d3562cd9496e9"
    sha256 cellar: :any,                 monterey:     "fce1d6958a7bfe325d971f506d7cc6dade67e9ce78f6211da1f8e5cd25b78bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1ba98c0c9c014651b55e6b23401ff0338c02032dab6c76c387cf76aca9e75f54"
  end

  depends_on "haxe" => :test
  depends_on "jpeg-turbo"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libuv"
  depends_on "libvorbis"
  depends_on "mbedtls@2"
  depends_on "openal-soft"
  depends_on "sdl2"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    if OS.mac?
      # make file doesn't set rpath on mac yet
      system "make", "PREFIX=#{libexec}", "EXTRA_LFLAGS=-Wl,-rpath,#{libexec}lib"
    else
      # On Linux, also set RPATH in LIBFLAGS, so that the linker will also add the RPATH to .hdll files.
      inreplace "Makefile", "LIBFLAGS =", "LIBFLAGS = -Wl,-rpath,${INSTALL_LIB_DIR}"
      system "make", "PREFIX=#{libexec}"
    end

    system "make", "install", "PREFIX=#{libexec}"
    bin.install_symlink Dir[libexec"bin*"]
  end

  test do
    haxebin = Formula["haxe"].bin

    (testpath"HelloWorld.hx").write <<~EOS
      class HelloWorld {
          static function main() Sys.println("Hello world!");
      }
    EOS
    system "#{haxebin}haxe", "-hl", "HelloWorld.hl", "-main", "HelloWorld"
    assert_equal "Hello world!\n", shell_output("#{bin}hl HelloWorld.hl")

    (testpath"TestHttps.hx").write <<~EOS
      class TestHttps {
        static function main() {
          var http = new haxe.Http("https:www.google.com");
          http.onStatus = status -> Sys.println(status);
          http.onError = error -> {
            trace('error: $error');
            Sys.exit(1);
          }
          http.request();
        }
      }
    EOS
    system "#{haxebin}haxe", "-hl", "TestHttps.hl", "-main", "TestHttps"
    assert_equal "200\n", shell_output("#{bin}hl TestHttps.hl")

    (testpath"build").mkdir
    system "#{haxebin}haxelib", "newrepo"
    system "#{haxebin}haxelib", "install", "hashlink"

    system "#{haxebin}haxe", "-hl", "HelloWorldmain.c", "-main", "HelloWorld"

    flags = %W[
      -I#{libexec}include
      -L#{libexec}lib
    ]
    flags << "-Wl,-rpath,#{libexec}lib" unless OS.mac?

    system ENV.cc, "HelloWorldmain.c", "-O3", "-std=c11", "-IHelloWorld",
                   *flags, "-lhl", "-o", "buildHelloWorld"
    assert_equal "Hello world!\n", `.buildHelloWorld`

    system "#{haxebin}haxe", "-hl", "TestHttpsmain.c", "-main", "TestHttps"
    system ENV.cc, "TestHttpsmain.c", "-O3", "-std=c11", "-ITestHttps",
                   *flags, "-lhl", "-o", "buildTestHttps", libexec"libssl.hdll"
    assert_equal "200\n", `.buildTestHttps`
  end
end