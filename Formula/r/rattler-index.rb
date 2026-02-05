class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.12.tar.gz"
  sha256 "f355a3948196a63022e6b21b5089110396aa3d6bf1359716fbee96bb07f20bf4"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e832c66809a451f61b58eb8a6c5c2b16d6c10d419dfc4e433cdce3dab100ecb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08611c7e6d9a0d502662ba48d0302ab47a53f67b14028d06521b06e9b5de10b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aad2cfad51aba85e246a58981949d132820a39b293e7ec8aa8979934506440d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dab2a70ea499f7017819e13ea722eddf409c772397a3c87b7008b60e5bfb5f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc659c4fe5fa6309146a94ee24ab66119c521dc6c997f91c64cbc585ad0eeec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b121abc41f10ec3ebe010cad8cf3a5ba3841e82a015a501c157e62cb3558490"
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