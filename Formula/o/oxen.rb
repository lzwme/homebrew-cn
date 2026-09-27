class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "09a8053627258d0c3b8c5e78257b39a82f31240ceffcbc3a03b7e604c7f06387"
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
    sha256 cellar: :any, arm64_golden_gate: "6888f7fb61a8953b01659e06ba855340ca8c64bb12e1a3a72609a03477e183fc"
    sha256 cellar: :any, arm64_tahoe:       "f0578e93fe6340e9d5c8363f2e4d645945da68c49ddcde4e1abaa02e1f223e3b"
    sha256 cellar: :any, arm64_sequoia:     "5af138036006e9ac17a8b15b0c3763c69f705111f99eb19f36cdc5cfbafa3574"
    sha256 cellar: :any, arm64_linux:       "a248d1308f9886527fec5e9908f1f63d2b93edb452b1b70d1af466696063fc1c"
    sha256 cellar: :any, x86_64_linux:      "067a94a85296c8a5e9d7c33712d05e55a846051dbad8e1a1adbb025e0a7744ce"
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