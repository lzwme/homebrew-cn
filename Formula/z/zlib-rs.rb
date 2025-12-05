class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://ghfast.top/https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c26eacb667c98dcb6df097b4755b3805bc26cd8a37dc8862e1c5cb1a295fe7ab"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe1f191c84e3afd6473d38eec57b4c1b7613989c83e80f238e6de5e75e583532"
    sha256 cellar: :any,                 arm64_sequoia: "aa93c0077e5236f9bcfff50a155b4dedaecf9dfcf8330adc4e74703b14e16b94"
    sha256 cellar: :any,                 arm64_sonoma:  "9bd41095be95da8036a6835ee2c67ee8071307cbb062b04c735ba93e45bc0ab2"
    sha256 cellar: :any,                 sonoma:        "36569c8c422da6af05d8218d7577447e63359114be15cc87f6c4f3825da63a7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aadc63bed073b000ba154abd326365bb9f6f3199eaffdde0614c956915349ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d96e87280ffff8785c375552a21be6eb79062a40391d056c925f626facde4b"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  uses_from_macos "zlib" => :test

  def install
    # https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#-cllvm-args-enable-dfa-jump-thread
    ENV.append_to_rustflags "-Cllvm-args=-enable-dfa-jump-thread"
    cd "libz-rs-sys-cdylib" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--prefix", prefix, "--libdir", lib, "--release"
    end
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "test_artifact" do
      url "https://zlib.net/zpipe.c"
      version "20051211"
      sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
    end

    testpath.install resource("test_artifact")
    ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}" if OS.linux?
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lz_rs"
    system "make", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end