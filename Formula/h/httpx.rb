class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https:github.comprojectdiscoveryhttpx"
  url "https:github.comprojectdiscoveryhttpxarchiverefstagsv1.3.7.tar.gz"
  sha256 "34a6fb8ed32a14a4cf3ea8308c8284b7ac7d8577305c17534fafd725650d0923"
  license "MIT"
  head "https:github.comprojectdiscoveryhttpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cd669733561f5ceb5289c9f6c1b914a987709e4ab4118473036480568a00aa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c42c20d2830331f7ddb499e078ac52b0e937f9454ae5bcc98d57bdf3bf14a640"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08b9a6904121f0a65cd1e4ad4e94342c104def5d051ee4b26d8d9be8abf242ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bac82496ca285a023872a9ba42537b3a4704ba3dba863bc9cea161e737faa1d"
    sha256 cellar: :any_skip_relocation, ventura:        "19c65d82ac2fbb6f11c45e33f32da865ca815e85550bddfffe9feba5afaa6b8a"
    sha256 cellar: :any_skip_relocation, monterey:       "1d8f57753a691a7050600d53fe7b4c978828426e1e923a7553e897f4f9dc4070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d1f67fdce9af4a75b77a1a480ed62845030658d99eb6d10d579e9071c1a48f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdhttpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end