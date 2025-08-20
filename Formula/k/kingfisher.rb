class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "66c05c1faa53f0c54ddff73a4be11930bcaf60c26014e704761182cf5f4ce707"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e77fbb05bcf4708441fb534a573bd69028ab517cba04a75d513a1e22f3d0a713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acef794d9b1f857fcf54c5f5077182a1e6e0158548d8bf44439651d67d020710"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25e8de875426bbfc195cb39bd935d0670710b5bdac12041865711f5134e1ea86"
    sha256 cellar: :any_skip_relocation, sonoma:        "98d906c41aa1cf0b40eca2a4ffe33300d63f47b3e96f794d2060b057dd5f0b75"
    sha256 cellar: :any_skip_relocation, ventura:       "c95ad83aae2a88543d66de12f2828dc7321c0d3d89dc9c4c87b9e10c31a37dcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25d63953d811d46de72302bcc766bd14591e97c738d83fdee93f35e26f9c7689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cdb6af0e9b559ac28d9edbed66fb39059bd9ad8b70177551967560bd2ae3fde"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end