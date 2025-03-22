class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https:github.comtrifectatechfoundationzlib-rstreemainlibz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https:github.comtrifectatechfoundationzlib-rsarchiverefstagsv0.4.2.tar.gz"
  sha256 "c1ddc10c38e50e9a465e7d76d6a5a8182656ae3fd35094af2b2d5c9606e58092"
  license "Zlib"
  head "https:github.comtrifectatechfoundationzlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87fd48003fbcd8c032d3d8fe59ce9362f21e2b1d38d4c479fac2c96ed7e077b4"
    sha256 cellar: :any,                 arm64_sonoma:  "80da2d68b663d36aaaa2b730a6fa61672ff6dea56f76f4f9d7f4be241147fea0"
    sha256 cellar: :any,                 arm64_ventura: "de491b402c9dd40f96b4eefbcf08ab9b46b852b26ec9f9fd26d16c38a860236f"
    sha256 cellar: :any,                 sonoma:        "560187385d4e908f454b6f323820707e4874c49a95d82666fb8c5a00c1b9279f"
    sha256 cellar: :any,                 ventura:       "299dfcf47452723f5bde1dda76340552fff351112a79a97eb785f1b9f7bf8601"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d989c3505015858b9dd3f2e8bfdfe62d6e3c2779a84c6e1d97d75873b4bf2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d67e3cfb2f3381cdcf1ba2c3f0c62a2bc90f0929175ea3ea8750ed77849af9a"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  uses_from_macos "zlib" => :test

  def install
    # https:github.comtrifectatechfoundationzlib-rstreemainlibz-rs-sys-cdylib#-cllvm-args-enable-dfa-jump-thread
    ENV.append "RUSTFLAGS", "-Cllvm-args=-enable-dfa-jump-thread"
    cd "libz-rs-sys-cdylib" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--prefix", prefix, "--libdir", lib, "--release"
    end
  end

  test do
    # https:zlib.netzlib_how.html
    resource "test_artifact" do
      url "https:zlib.netzpipe.c"
      version "20051211"
      sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
    end

    testpath.install resource("test_artifact")
    ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}" if OS.linux?
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lz_rs"
    system "make", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output(".zpipe", text)
    assert_equal text, pipe_output(".zpipe -d", compressed)
  end
end