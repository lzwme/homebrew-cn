class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.25.0.tar.gz"
  sha256 "c2d03c17ac33c734ad88be043b454d34f4f938f242f1f37267c3f2f37ac4ffb8"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1df974fdd6e3d39c5a741bd51f1c5113f5eba6afc7dcba847af4300fc239d4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68bf7c2a53dfdeadfcf20c95d0c2e7fe48e6c07146fc6991ecaa75757fe5696"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3c74b396f66c3d49bb0059e8cedaba7a29199f474c12efd223ff378539b1640"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4cb8044d63d2fa85e48e4aadb65dcf0b7d561a8cc061d8e7a33ed8609a5e259"
    sha256 cellar: :any_skip_relocation, ventura:       "9b209d0fa7bf4b0df4ec9431fc6d936104f03d6af2881f5277ed29f3626111de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fee692076119f0e3ac0df152adf57eadad93641560505626c335593319aa931f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238d4daa0f2be881d0a37cadad5f84338b5f839260f7bf483868c7486fda4950"
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