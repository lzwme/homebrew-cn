class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v7.6.4.tar.gz"
  sha256 "4bb7b63bbf17c146a7588bb982c4bf4bbcbd5bde4baf26455d9f69eae4ab5077"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a07619a336d064f5d4799f47e4e8a917d9f7db8fa9b4a329f3d760b9f3826d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec6f3b1dd12fb1922df05bf01c52fec86275fc81e8f7a9690c0676100731385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e816a29d35910187da8f6bf615eb8f13be593a0dba142e4f2756da9b19534956"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1786ad456b5d256fcf2905a1b489e3772f462a2b25a9b64c6675831f2b3535b"
    sha256 cellar: :any,                 arm64_linux:   "c131720afd178d78178177e2bcd0f91cd3466cfb56d4a8e1c5635ee57c819f4c"
    sha256 cellar: :any,                 x86_64_linux:  "da8dc579e014d47cfdb684ca5559c2623e468247f1211587fc71516e365103fe"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Add Homebrew lib to rpath so dlopen("libonnxruntime.dylib") finds it at runtime
    ENV.append_to_rustflags "-C link-args=-Wl,-rpath,#{rpath(target: Formula["onnxruntime"].opt_lib)}"

    cd "bkmr" do
      system "cargo", "install", "--no-default-features", *std_cargo_args(features: "system-ort")
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end