class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "f02b9e54edc04b53b9ef2846812cdbe5d67aed61eaa67b5c88a81de43e778f3c"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7c6a63bff435b4c34ac7b4ff904fdd63a25ac346a3138707db037db96f8455df"
    sha256 cellar: :any, arm64_tahoe:       "13896fff2bfb5d2eb3b28617f92bd8763cc68df4e10172e3021b19cd8329aade"
    sha256 cellar: :any, arm64_sequoia:     "e75567b735c0cae997242ea314c4c3f23c0abd6ce8eec40f3cc6783ef737506e"
    sha256 cellar: :any, arm64_linux:       "5b38b25c6cd07418b1ac76bc54c45aaae304655a4f41dacc993f293a905c6f89"
    sha256 cellar: :any, x86_64_linux:      "13d5c8a12d0f2d58d87a24b50bc29cb8143339f15d2d8dea64863dd2854caa92"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["ROCKSDB_LIB_DIR"] = formula_opt_lib("rocksdb")
    system "cargo", "install", *std_cargo_args(path: "crates/oxen-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end