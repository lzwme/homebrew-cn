class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "47d0875fb3d78fab05f91ee0e7be7a971c502b1ebf4a86e20868e5a10d9b0a0b"
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
    sha256 cellar: :any, arm64_golden_gate: "c7185bd9a5e67899388f40a0aafbd88e17cefa29c15d6f47bf932ab6c16ee94a"
    sha256 cellar: :any, arm64_tahoe:       "cacd6daed7237313b86fddcc0aaa0a58038a7266822fcd969bfa48f4eedb29dd"
    sha256 cellar: :any, arm64_sequoia:     "b781f3801d91cd6ff009cb3e37bbed82df021887c900861ddbd62ed8e8e6bffa"
    sha256 cellar: :any, arm64_linux:       "2ead85695a34a4d0082fde77932d0d4501163216266e44aae862ce8462ccf5e8"
    sha256 cellar: :any, x86_64_linux:      "6f510bdf8efb68413ceb7b097c7262c421a34ab91b7f4e8bfb4975f25c76bb37"
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