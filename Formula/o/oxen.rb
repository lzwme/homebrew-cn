class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "a7c04a42fe1ae84734d3e8811fadfe16db5cf6fe04436297b7f0e4ee47ca2c4b"
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
    sha256 cellar: :any, arm64_tahoe:   "9eeedf7698861a68289a55a1bd8cce5719f08a717d755be27922d9cbe4bc3b79"
    sha256 cellar: :any, arm64_sequoia: "1ff04b59bc62e687ec1a8d12109daaf86f4ad7475ee633950834bf846b8a74ed"
    sha256 cellar: :any, arm64_sonoma:  "8185895d94e0c1919a09f14d6cb928f2179291434854bb7d89a63446d5e45b35"
    sha256 cellar: :any, sonoma:        "d784565d6e17db5d16424c3080b900039496cb9343f4c6ee3a1e8329ab4ec157"
    sha256 cellar: :any, arm64_linux:   "fa9bc570dd8fc729e83bc4501975fe7e2073f12bec41dae14b41a050e543af27"
    sha256 cellar: :any, x86_64_linux:  "3687b967c268dcea2d418188a8af9099462d5cb4d294a58330e01daaa1c3d04a"
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