class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  stable do
    # TODO: Remove `extlib==1.7.9` pin when upstream fixes https://github.com/HaxeFoundation/haxe/issues/11787
    # TODO: Remove `ctypes==0.21.1` pin when build fails from pointer mismatch (i.e. `luv >= 0.5.13`)
    # Ref: https://github.com/HaxeFoundation/haxe/commit/e646e6f182c920694968ba7a28ad01ddfee4519a
    # Ref: https://github.com/HaxeFoundation/haxe/commit/0866067940256afc9227a75f96baee6ec64ee373
    url "https://github.com/HaxeFoundation/haxe.git",
        tag:      "4.3.6",
        revision: "760c0dd9972abadceba4e72edb1db13b2a4fb315"

    # Backport support for mbedtls 3.x
    patch do
      url "https://github.com/HaxeFoundation/haxe/commit/c3258892c3c829ddd9faddcc0167108e62c84390.patch?full_index=1"
      sha256 "d92fa85053ed4303f147e784e528380f6a0f6f08d35b5d93fbdfbf072ca7ed3e"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e8b9ac34567f3367a0d6e420c3a64782113cb4b279bdfe405c42e74086c45b8d"
    sha256 cellar: :any,                 arm64_sonoma:  "7b578bd443368559647f8f4b83b4f8836f57a5d753fb039dadfbcdbe7de79093"
    sha256 cellar: :any,                 arm64_ventura: "20d95b7e36e2332cb253d226ddd5d321376235aa505e2a0a5ae20bdf023b4a6f"
    sha256 cellar: :any,                 sonoma:        "bc78b84d45023ee30a3dc005043d89171b3bd3489a917670bff5d91aeb48c6bd"
    sha256 cellar: :any,                 ventura:       "23effcc0f7131aa4c4367a357b1f6f905bfaf214ee08ba83d15e57b211680a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f095dbf4adcdbc71e5a95b089f67c25d9955e4f1a2dc4f1e158ad63491a2ae0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b93448c64ffe1c9250e868fde52012b3cef2543b4954e7e24697a221c57b645"
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "mbedtls"
  depends_on "neko"
  depends_on "pcre2"

  uses_from_macos "m4" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "node" => :test
  end

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "IPC::System::Simple" do
    url "https://cpan.metacpan.org/authors/id/J/JK/JKEENAN/IPC-System-Simple-1.30.tar.gz"
    sha256 "22e6f5222b505ee513058fdca35ab7a1eab80539b98e5ca4a923a70a8ae9ba9e"
  end

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["ADD_REVISION"] = "1" if build.head?
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "exec", "--", "opam", "pin", "add", "ctypes", "0.21.1"
      system "opam", "exec", "--", "opam", "pin", "add", "extlib", "1.7.9"
      system "opam", "exec", "--", "opam", "pin", "add", "haxe", buildpath, "--no-action"
      system "opam", "exec", "--", "opam", "install", "haxe", "--deps-only", "--working-dir", "--no-depexts"
      system "opam", "exec", "--", "make"
    end

    # Rebuild haxelib as a valid binary
    cd "extra/haxelib_src" do
      system "cmake", ".", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
      system "make"
    end
    rm "haxelib"
    cp "extra/haxelib_src/haxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}",
           "INSTALL_LIB_DIR=#{lib}/haxe", "INSTALL_STD_DIR=#{lib}/haxe/std"
  end

  def caveats
    <<~EOS
      Add the following line to your .bashrc or equivalent:
        export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = HOMEBREW_PREFIX/"lib/haxe/std"

    system bin/"haxe", "-v", "Std"
    system bin/"haxelib", "version"

    (testpath/"HelloWorld.hx").write <<~EOS
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    EOS
    system bin/"haxe", "-js", "out.js", "-main", "HelloWorld"

    cmd = if OS.mac?
      "osascript -so -lJavaScript out.js 2>&1"
    else
      "node out.js"
    end
    assert_equal "Hello world!", shell_output(cmd).strip
  end
end