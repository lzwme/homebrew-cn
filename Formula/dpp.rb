class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.5.3",
      revision: "52c7e845e1158208847cb299e9f8ad5377429027"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5021696fe689678470a64ef419451026966b7028012f440796a42a1e9314aae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f24fa2bdae5c9a967342eb59a2264079be4c3ce16c5f0516b92ae87aa65ddf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c03d14de31167881c66d21431452d8e46a2345fd0016dac0bf005a64524e82e"
    sha256 cellar: :any_skip_relocation, ventura:        "71e37fc9821ca4e400ff5fb907af4d98d042fbadf0524d82dc94ff7706477831"
    sha256 cellar: :any_skip_relocation, monterey:       "1378d8f5b03142b008c4d1358fec0a28c786198f9c433f12fe602848b8ae8ba2"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c0e6133c84d329addfab43b5de6d12518cdb59ffb4e69f15e643b3200047d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09a5b4ec29d46d9bd7a80729752d0ea263953936a226108df53fa5bf2d85c03"
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