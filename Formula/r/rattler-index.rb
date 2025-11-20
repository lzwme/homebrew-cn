class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.2.tar.gz"
  sha256 "3d6d7ee45b3c371759e0b419ab78f9ba141887bf14b6ccf4317135c22f346864"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51b0dbfdf5fcf5fd183c3cb0e6341ff9da29113aa9688252bd8f9a139f5bdac4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33951c6ead136446c1ece9ace3eb77a43e7b9e5cd001c252f637316769da6e36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55c741d5f72d4e706e79a7cdc6c8f2b88102631dbcdba2b8790d43ec97c4870b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8acca7989429847293336363703a58928af15efe8729501f2ee72ed75274934e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6490dc9490f642f674b279376424d6023349430c43afaf587c8d110ca3bd96a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da5c362b33713aa4477feea9b708f64f730c2d7a3e3b242347a3400a7bed833"
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