class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.5.1",
      revision: "23339d566032419501b005e13f601bb6b6b1ebe5"
  license "BSL-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04399f95b0fae7c0f542155e5c17a3fdd8889dfa42de78069ca70d5a2f54e138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adfabbdac982965b03148f7955a5a04230a2bf25f33f0ffa0005a0381fa422ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae1003d31e23fff5adebd6f0ce12df581395ae262670465e50236a490d8bee4a"
    sha256 cellar: :any_skip_relocation, ventura:        "a23ff111cdad3793c3f18275a5a7925ccb3b00d8cf6fbe20c99223ff21b7a9c5"
    sha256 cellar: :any_skip_relocation, monterey:       "2f653d2b80bb65c1e6751a65900bd4229ed8c812eb14665e0ec2dc841bc84467"
    sha256 cellar: :any_skip_relocation, big_sur:        "e26e0e8af8c013d1e3bbe8eb83228b9d9cd596021c8ca7115c5e0a80196ce761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217a38e243f6b931307b1be30a278432b66674bf9061f5a534fb452a01de7cea"
  end

  depends_on "dtools" => :build
  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  uses_from_macos "llvm" # for libclang

  # Match versions from dub.selections.json
  resource "libclang" do
    url "https://code.dlang.org/packages/libclang/0.3.1.zip"
    sha256 "ff6c8d5d53e3f59dbb280b8d370d19cb001e63aad6da99c02bdd2b48bfb31449"
  end

  resource "sumtype" do
    url "https://code.dlang.org/packages/sumtype/0.7.1.zip"
    sha256 "e27e026505bd9a7eb8f11cda12a3030c190a3d93f6b8dccfe7b22ffc36694e4e"
  end

  resource "unit-threaded" do
    url "https://code.dlang.org/packages/unit-threaded/2.1.3.zip"
    sha256 "bb306506cc69f51e3ff712590c9ce02dba16832171d34c0a6243a47ba4a936d6"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"dub-packages"/r.name
      system "dub", "add-local", buildpath/"dub-packages"/r.name, r.version
    end

    if OS.mac?
      toolchain_paths = []
      toolchain_paths << MacOS::CLT::PKG_PATH if MacOS::CLT.installed?
      toolchain_paths << MacOS::Xcode.toolchain_path if MacOS::Xcode.installed?
      dflags = toolchain_paths.flat_map do |path|
        %W[
          -L-L#{path}/usr/lib
          -L-rpath
          -L#{path}/usr/lib
        ]
      end
      ENV["DFLAGS"] = dflags.join(" ")
    end
    system "dub", "add-local", buildpath
    system "dub", "build", "--skip-registry=all", "dpp"
    bin.install "bin/d++"
  end

  test do
    (testpath/"c.h").write <<~EOS
      #define FOO_ID(x) (x*3)
      int twice(int i);
    EOS

    (testpath/"c.c").write <<~EOS
      int twice(int i) { return i * 2; }
    EOS

    (testpath/"foo.dpp").write <<~EOS
      #include "c.h"
      void main() {
          import std.stdio;
          writeln(twice(FOO_ID(5)));
      }
    EOS

    system ENV.cc, "-c", "c.c"
    system bin/"d++", "--compiler=ldc2", "foo.dpp", "c.o"
    assert_match "30", shell_output("./foo")
  end
end