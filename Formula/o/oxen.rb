class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "3ff8c51cef5c8fb2db4baf440b6489183be361ca72b0aaaf8f56e64fd8e9d96a"
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
    sha256 cellar: :any, arm64_golden_gate: "4e6cdd9c4d87409586d139eafddea97fb49cca6c88c6727c47ccb6359cac425e"
    sha256 cellar: :any, arm64_tahoe:       "2746363c6ced2c35f9dbd5259db3a137239a75a2154ad24d9e386851cc4d6ca2"
    sha256 cellar: :any, arm64_sequoia:     "a4309a272fcada683debf6a092e2fbd990ecbfc471f6f786c27a67f5d15179b9"
    sha256 cellar: :any, arm64_linux:       "94daba04bf952444280a12d6ed198d3549a0cebd60ae63572f54ad0a9bee68da"
    sha256 cellar: :any, x86_64_linux:      "5f4ce304aceeed53258d98fe0ac8f68879f40900a8d6a27d2ff0d45b30cce2ab"
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