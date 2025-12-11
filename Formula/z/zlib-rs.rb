class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://ghfast.top/https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "1069ad8b8dab0ab3f3d7ccccc380c81709d13f788f57b7ca167db774778ec1a7"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c04001c73664ad59d758dc812cdeb8f66d39beafd8fc71c6b98792e5c7e0d864"
    sha256 cellar: :any,                 arm64_sequoia: "e479aaa0cab4b01239e687ac474d80b11692d526b77abc6658d174198d499cce"
    sha256 cellar: :any,                 arm64_sonoma:  "8cb3161ea6d5395aa84d68be21e8cbf9cfcccf9982ab8c4196c2b454fb0937f0"
    sha256 cellar: :any,                 sonoma:        "20381afd60cc9322f0b15438c06d8049e37ff092b9c6e384408fb4c126085a6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f68cef7701cfabb0d2d25ea31296ca64a6bf3522322a4e1947067d9599d5b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "851b64b4ac79b538933b6b2a151a4ad874e04067b45dc983173188250820b107"
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