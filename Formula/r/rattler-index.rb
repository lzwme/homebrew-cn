class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.12.tar.gz"
  sha256 "5a751f7c12d2fda5f2e48221f7dc38459e84ccaaeedc5442c7089c59331572b1"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deb67a3e6f8e282139a12086551292c1454e09caa96edd385bbfb2e788747919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94999885794a2f69d1307fa96d45bc07e551a2c590fb488fa8d37becab874d62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8fb7dfdd942b32bcfd16d8ee4fbc7f63d0fc03822d4acb5532cdd447b91cf5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4987009f306d4e046b41a0e48a5852a16fea927fe1136ba2408a84376599de38"
    sha256 cellar: :any_skip_relocation, ventura:       "9c003b0e97627e81eed49fb09ed6a17cf676d8e681bacd2a1c96ebf9432d1ff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6132192f16b0bdfe62d59b6b438938ef2c2676f2e1ed32fb40ef53e4a6aa581a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72aadf6b9fec759835a8b895b55a68d9e9173f79488647040f6ae53461990714"
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