class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "030352c4656927136f04fc33ee19653c4e88ce5554dcf55055ea001b4aa12714"
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
    sha256 cellar: :any, arm64_golden_gate: "eb3ece38c842329610b6074ccbb12aa598bc935f62f68e212446509199504306"
    sha256 cellar: :any, arm64_tahoe:       "5b145362fd0dcd5dd59a6e124a5e4f36309a7d72c5781a2f59480e458d6faa9b"
    sha256 cellar: :any, arm64_sequoia:     "1ff7fead9f4a399fa408db0f1dab2ec1942deef40b8fcdbac38f403dcfccf2d8"
    sha256 cellar: :any, arm64_linux:       "3eef5b1960c03fecfdad6d6b8114983e6ad5d2189266c4734d7534dfbeeeb31c"
    sha256 cellar: :any, x86_64_linux:      "fc1ec3b3038ddd3ec8b66c9f634e8d55285b771cb86ce5d6dedbc7a2ae996e87"
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