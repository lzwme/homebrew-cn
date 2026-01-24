class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://ghfast.top/https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "4b18b072127af931239b3f65d708e71fa074ec9bf973973067ed80668c7b3be9"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19c8f5a8517752b647ecd3b853cfb01fdb46925ab12ca02bd65047e5c786dbc6"
    sha256 cellar: :any,                 arm64_sequoia: "43b10da1eab03efcb0e50bc277ba3b72715503c0a247a50c0f74d5799a8e776b"
    sha256 cellar: :any,                 arm64_sonoma:  "b85b8863dc0cd2e5d2098219006b75dc2cf3dd0e54aa7e3085e577c1b490e373"
    sha256 cellar: :any,                 sonoma:        "70faedde8a81552d859b118a10b685acc23cd46ddd9cd44275fd47060c73a0a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63eaf5c1cddf341784563a182dfd1ba5ac2f2609b359a73a950b149e6267111f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "364aae1b5ac613cca65411bdbc01c1222b506a3d2c4a1eb5cf6fb93926ee9ea6"
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