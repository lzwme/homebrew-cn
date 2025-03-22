class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https:github.comcondarattler"
  url "https:github.comcondarattlerarchiverefstagsrattler_index-v0.22.2.tar.gz"
  sha256 "6fd3f05a4b7c4e4fef6de4a3685abcee38324abd6bce1ec8e39294dc1f5e0e14"
  license "BSD-3-Clause"
  head "https:github.comcondarattler.git", branch: "main"

  livecheck do
    url :stable
    regex(^rattler_index-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ba524f263497f2a5f11c69547179b23270b019afc155907d6dacfcaa32c061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d8e8acc111fc43e31a5b77fd7436756c9afb06499a24b226a3c0fec37a67973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92b80fbe71f0f6e744da8b97f97d353df1b607630d624c7d189ec45fa21f9e99"
    sha256 cellar: :any_skip_relocation, sonoma:        "456c1ecc3e7bb4edcb82971d9511f9a69e3a4128f5bd5c11c0112d5f51939a35"
    sha256 cellar: :any_skip_relocation, ventura:       "852414fae3f2810dec8d1bdd140038ba3863a54b115c378ef8503c1a6029babd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "564dee019da1d3aaa61ad518305e3c183b464ad5539407f481c1f7a549ba3537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a8e672588de6af667e16869c8626432ea4120fd931d4498001528710160148b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls", "--no-default-features",
        *std_cargo_args(path: "cratesrattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}rattler-index --version").strip

    system bin"rattler-index", "fs", "."
    assert_path_exists testpath"noarchrepodata.json"
  end
end