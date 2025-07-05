class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.227.tar.gz"
  sha256 "cd1bef15db472c6d8deb72d5bf59106d3e6fa21ac364f5d91742c832a87e8a45"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f628481b8bb13aa2e90ec2100425a8a323ebbad1339774cfc7f0334c6478cc2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f628481b8bb13aa2e90ec2100425a8a323ebbad1339774cfc7f0334c6478cc2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f628481b8bb13aa2e90ec2100425a8a323ebbad1339774cfc7f0334c6478cc2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bae208f6d302d9c216eb9bd3beabc1cbd655f0b227270e1fd5cf0afd6bd3f69e"
    sha256 cellar: :any_skip_relocation, ventura:       "bae208f6d302d9c216eb9bd3beabc1cbd655f0b227270e1fd5cf0afd6bd3f69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93271f1409fb397b16c81a1eab59be7e6a7715e49fd1284c7a14df9621484b21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end