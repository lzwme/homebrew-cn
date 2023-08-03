class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://ghproxy.com/https://github.com/golang/tools/archive/gopls/v0.13.1.tar.gz"
  sha256 "e59a87ebd380d25e76701e163b9dd447b0c3ad94b5f7b68885d0cc94d8d956d3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c112477a91332d8b5c7054d6e7c02269c1782d9b38bad020fbb53cd6caa5116a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1762fa83236b6bd71f4a097b1b29a70b01015136968a051225a732c885e5436"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0479f0cf36e7104d9bbebe8b9cba48e218b8cf907262971f17c7837edee1321c"
    sha256 cellar: :any_skip_relocation, ventura:        "83e618c4a6cd021985651761d971b68753d3b0fccdfb6b4fe87ee3a9c7520296"
    sha256 cellar: :any_skip_relocation, monterey:       "e891d004de6bde723750ba8e953379df369d1c7b7e2bf6123601d9cd2180e1fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9301abe8ff31476f2eeb08965ef67a03199c46c99339058fc1e51f6500b55bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6336671f92ae6a0318b9df10351f904b59eaf3edf4a51f80acfa117ef3698295"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end