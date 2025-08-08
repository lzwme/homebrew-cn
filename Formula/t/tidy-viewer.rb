class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://ghfast.top/https://github.com/alexhallam/tv/archive/refs/tags/1.6.5.tar.gz"
  sha256 "42a7fb627d91930225590c9773cd6efa6f32c779c3dc0ea96a8a6c88e78eaba0"
  license "Unlicense"

  # Some tagged versions using a stable version format are marked as
  # "pre-release" on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "426647c1904878cfd8914cfd078c80e361ad100819f909d5f5d82e08fef5daa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6253cb83ed02fc269b0c03b92e40b3704c171614d763493338bb31ebad359281"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "760539811a3555d03293e8b374ba9ab95ee9fb95f9dcbefa4f272718f9dd9980"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3c534dfc8f4dc35850a7300f77389edd493420ab7c60bd6ced295507fa5f425"
    sha256 cellar: :any_skip_relocation, ventura:       "cb191f88bf8a648376ac2fa04c1898c1931edce4e895e60125efec4cf2140339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d641f61200120969695d246cff3e248bdbb7c301466e8ae27a2532fe37cf707d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfdd46c8091bfcdd27ad57e8fb6f15322e24854eb26ffbc530a40735dc3e9cea"
  end

  depends_on "rust" => :build

  conflicts_with "television", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end