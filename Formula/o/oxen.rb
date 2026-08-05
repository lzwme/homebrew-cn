class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.52.9.tar.gz"
  sha256 "b141988d09ae91196c8b8b9474d9e7d5d088bae7cb19f28e5786c01bb585604f"
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
    sha256 cellar: :any, arm64_tahoe:   "800b050040f38d400b6a30a7676e5a207b3a41d5ca35025bb4bec054456ca2dc"
    sha256 cellar: :any, arm64_sequoia: "71deae91183a495c7d125a793f9008885ab63c9366e98d0e69ec582bbb372c00"
    sha256 cellar: :any, arm64_sonoma:  "b52fb11ee077355f83c6161e7067d8e85aaaf6e29a5a4201ad0e61b91e3a265d"
    sha256 cellar: :any, sonoma:        "6904128dfd130ee06b8794f2a2c6170579db5d99cb80c32dada15f7ab5baf8f7"
    sha256 cellar: :any, arm64_linux:   "9563062cbc611a7360259c4612798f0fafca28690d4c3400da7db4427dba30d9"
    sha256 cellar: :any, x86_64_linux:  "70790972f44886cfda7182ac7e718718dd143f764cb729b12f2b0a132d796a54"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

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