class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.5.tar.gz"
  sha256 "049e47eb91b07574aa24c35c32a92b1d610d1ae88a62ccbee53790131d527d43"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e588008acdba9b370c5a56ebee02a96ac4fa5d3c97c94c01dfd77a85bc93f24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd6891c9d8380377734a6354eba2bd8f2e251d490fee94896cde54c5b28fbd26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a8561d66520fbb5664fe1667366f5f49b0bda9a4c01504e6b990004d7166d82"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6e071891d1e76725f1fe98dfb9796591d7938088eaa1e2ff3319b60850909a"
    sha256 cellar: :any_skip_relocation, ventura:       "7df3b803d6cf733287f38b624bcecef0f252002f91f4ba19d1e11991467b16c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e9d168c97ee0796e67ab2ac737a187a67461a2551f5d054d699ca990c2f999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31a629226b2d7f8ae1bc24a895a8913294e5b6771bf3b3d5785411a8f14cd100"
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