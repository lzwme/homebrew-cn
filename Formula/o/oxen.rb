class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "197bd1968307194c98bfa177a5b3a151942c4bb5d9826be3ca2a1b15a33e598d"
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
    sha256 cellar: :any, arm64_tahoe:   "4d3a1ad079fffd9b04212f395d9f7d189f2a3145a9cf2134744723077e62a9ae"
    sha256 cellar: :any, arm64_sequoia: "eef16faa567a215927f966d30b3294b1b0c356d975203fe3ddfcaeb7a2adf2a4"
    sha256 cellar: :any, arm64_sonoma:  "0f47b1711a7176e4ea6f708041d75bf777d610306da95f443bc5c7af80aa1f1b"
    sha256 cellar: :any, sonoma:        "c7a3e27f2827d36dda54a1d59f353174b2f353297a4d406413772ce494c53bdb"
    sha256 cellar: :any, arm64_linux:   "9be6100ed4c4dfe3a397fbbad1b667d0a7e86b983a4142405b27733bb85f344a"
    sha256 cellar: :any, x86_64_linux:  "6434e1ac5037fd001190f697b37165d5d6b3daeee1a99c21f838a7f8d0f6dd60"
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