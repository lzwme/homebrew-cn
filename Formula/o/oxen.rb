class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "4bfedb0205ab7a9c967f6ecda40b39d2684d8ccae7a55106b3c85a13c09ab400"
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
    sha256 cellar: :any, arm64_golden_gate: "e67ffa17b515d4faa389f0244b830dff42b488eaaae74dae191737b488039979"
    sha256 cellar: :any, arm64_tahoe:       "c4e388ee9c5cb4908513e1ca8f2a3c9ed975ec66d33f24bb4bfb7e289c403f4a"
    sha256 cellar: :any, arm64_sequoia:     "c25c40ba04bfbd316f59f5bb2574e4b2f8de0195cb4cb02a0011beba0784db79"
    sha256 cellar: :any, arm64_linux:       "5a2768af38825e44ceda1be57952931b17e47ecb6b696bd43af54e4a314d80b4"
    sha256 cellar: :any, x86_64_linux:      "55133893aa868f8a0afc748ec2f8472bcffae37845cd12e282d09af8c97388c5"
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