class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://ghfast.top/https://github.com/alexhallam/tv/archive/refs/tags/1.8.92.tar.gz"
  sha256 "acc42d295bd9d1c960140ecea52aa74d682dab3e44529b72b1d5c71a87e32315"
  license "Unlicense"

  # Some tagged versions using a stable version format are marked as
  # "pre-release" on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c008d0f0c35535841b576e795aee36a099f8d7c33a8072309d8b3a888188ddd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cec65891cb4ec8c0d7e00a221c4e6c77e9431731ea79f79ab7916173e85de8d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "646cad77229285960aa52450142803df64993521b41dd143a05b4bd60d1c8e56"
    sha256 cellar: :any_skip_relocation, sonoma:        "e85d7c1406dae52bfe182e82799d2b700aab4ba8ab9b6ff16873d1c5bfde1630"
    sha256 cellar: :any_skip_relocation, ventura:       "ca3893e62d69d652a91c780392ff1539c9aa1974d7e7bfbe08c40a8885033935"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c45f4393454f66b64b81441787ecbf3ec4697c11beba11f71230e682163ba57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904ed9d486c626c0a9392dce5812ef8950c03ec3f7a87184887c90d3be7474cf"
  end

  depends_on "rust" => :build

  conflicts_with "television", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "tidy-viewer-cli")
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end