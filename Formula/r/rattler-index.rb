class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.5.tar.gz"
  sha256 "b5746247fbb3ae1791b0e1690ec68f420d199996437314e544cf8c4eb05f82ca"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5192db1aed85710f27d8bed2a3b44cd614831bbc7a8261d5d801b12790948d12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df26dfc2e02b8701db14f891ed9f7248cac1bd6506036a9164de2f675633557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c13640623a1e687aaea3aa8bb9b4288e9f12815ad8f15fc559a8831ea1e2e343"
    sha256 cellar: :any_skip_relocation, sonoma:        "07e689542f1e2913f08f07fbb2928472b7d282b349c0dc886df9bfe82c020f07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f57105e36448ce1146b43176832c300943b5c790935cdea83bb88ee1556b1cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad34fea05de7ca294e7d230fa3dc236adab96d64ce5038ae21b86a324be741e4"
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