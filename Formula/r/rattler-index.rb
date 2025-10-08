class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.25.5.tar.gz"
  sha256 "1c2af51a1afffababe1ede02deaa6c1c41433897a260ccc2cf19bb16c6be07e8"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8827bbb936b6912756b5e67a8379074fcd2c1e1df3dd7404e272b9e3067cffcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b8c0fa085ed2cb05bff7bb0cc9a88e80affd6dfa360cda6bb6e79c6f04fb0e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "657771b9ca464416d167a11b743bcbcd0e3a48520275286851ebb79726d8cd93"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab1878e544fbb4e279422d268c4befa414ef18bb1eec5763c43a81bcaa4d9fff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65a8c897f0b254f38d434c97b74a285df1e5e457d770cc33280b403c66d9de7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ddd417d122c168f71eb46b61034364c845a72d89b644ed399b8f4ab5965120e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end