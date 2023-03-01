class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://ghproxy.com/https://github.com/alecthomas/chroma/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "ad0bce3d6ba4397a866e5c8728c146fb370a2b0adb1d35fccdf7d515a9c7f553"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e4889845ddce854637e224f4cf4ed59e1f716b92de4718350e17503527acf3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ded385775f84ae171c849dd9703958f971cd60e9d8e59e3b6074f0523a9bc09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0e4ed00aa01eb204acb20b4a9ce0df01f63d5679e2bdc8a912dbed33ff63bae"
    sha256 cellar: :any_skip_relocation, ventura:        "31a81973322299347854d6d345926994085b0fc0def31ec5b5be101fd412ce98"
    sha256 cellar: :any_skip_relocation, monterey:       "e2129fce44a5a21346108c6189f3d71a3eb73302a54b7903eb722da894407d26"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee54d945456962981db50803d5b1b6d9b9d4c4fdc3d10c1599a1143d7b083ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9fae77d46027c1186162003bcc54cda72289971e909772a1a801cfa490c1453"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end