class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://ghfast.top/https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "270dedde7e1cd63e7a743a520a74b92e82aaf02a2cb7e5e461364f58a03cc720"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "56639a1603d37c414486e9cb284cb5a6f20619bae756071bc1d23054623d42e9"
    sha256 cellar: :any,                 arm64_sonoma:  "790c1ac316f2f58806dce435c83e864c16dd7712cb79c5c55af49f62a08efe18"
    sha256 cellar: :any,                 arm64_ventura: "8c5523144dadf9f2d14d271db2ff1efbca829352aff7d68c15a92fde83bd519b"
    sha256 cellar: :any,                 sonoma:        "a841cc713277c0c393931d6cd8f4e234c8fc2a20abb62e90c74d7aa4519a2853"
    sha256 cellar: :any,                 ventura:       "1fa3f5dd302754ef4af4c22e8cd45708e6317cb7acde893d1e4dc3284eecb7ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63722b2d31982a172f1e349321cddcc343f282c74ab1457c3bdcc504f09f9542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c4b6ffaea988af8867051c8631f07c8091aee39e9271472e2468fbddd3d0473"
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