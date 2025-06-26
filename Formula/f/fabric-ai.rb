class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.215.tar.gz"
  sha256 "73b69dfa308040fe2941302d188a26cc72fa2c106d5c6ffd18f0184ecb08ca07"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "237946714814ff2e86fd2a82c326bb556287d0a18889fdac2cf3e387ce78f667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "237946714814ff2e86fd2a82c326bb556287d0a18889fdac2cf3e387ce78f667"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "237946714814ff2e86fd2a82c326bb556287d0a18889fdac2cf3e387ce78f667"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b34c1e56398f5c33a258b9f61e44adc64222b328b0d389a2e725a934416cbc5"
    sha256 cellar: :any_skip_relocation, ventura:       "2b34c1e56398f5c33a258b9f61e44adc64222b328b0d389a2e725a934416cbc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b28e3d8019ddab9dcd8f6230c35eb966e6f60c2792e42a5c9cdf41fe35c4d5d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end