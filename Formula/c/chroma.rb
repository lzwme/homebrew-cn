class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://ghfast.top/https://github.com/alecthomas/chroma/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "93be896c9bc8350217fb5b392798e2481b9bcdaf6450b47b81de218807b798a9"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dd6a3d666de80da497129c5aed18146e637de66c0c31b1033c46c1e79982332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd6a3d666de80da497129c5aed18146e637de66c0c31b1033c46c1e79982332"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dd6a3d666de80da497129c5aed18146e637de66c0c31b1033c46c1e79982332"
    sha256 cellar: :any_skip_relocation, sonoma:        "cce0bdf234df562789eb567c7e233c6699e2717b5eff08a3e6c5c6a71d7ab0c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef403b02583e587b307023d62b4cdd02c80bd48a52c973eddb4f73708812b9c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a58e99aa29e37905c61bf8433c395b2153f0a0259ac64b82cd93a7e114c7db"
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