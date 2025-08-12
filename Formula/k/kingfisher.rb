class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "57b827cbc611567d81cead61ccbc78ed5ffca78750c3f07c38f1d1b0a355b9ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71c357df254cecf3606fa62058e1b59d1601691de41b79ec7f8a9f1473a59d03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4b8229d25d925e8cd0cc9060f8cf0791cf104dece61763f2fbd5fce40b26868"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ca11482ce916278197eba88f44a1c348ef53e7960ba96712ea39c6b338b5a8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "170438f6b1fcdec10232ca43ea899f839df450e2fda1cdd302276493093ef1cf"
    sha256 cellar: :any_skip_relocation, ventura:       "4a4374d3f5a6e878eea7c464e7bd95bd9b39e19678eb6af1ed209348cf503535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53daac525bbdb1dd8d36fdd5dc69521cd56955586a299eda79ead78727fcb248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f907467f6953b795b55e3ea58c97b8acfc8b6b69380f4d78b6a1a76330cc0bc"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end