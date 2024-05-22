class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.23.0.tar.gz"
  sha256 "2b3a984fe7687f319b203c0a95ded8f54e060aa958e6bee4609d13b239c0dbc3"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a506018b49b243d8c4ab256bb9dc37ee7e600e952eb3d8977b343423531799c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f2075d21eaa1de3d58358f4e38a215f4f85a26dfadc3e64adf6e96808121256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f80d7ddb9624da58ea6a3e39b93e55855c3df24128421167ad9b44d33363c81"
    sha256 cellar: :any_skip_relocation, sonoma:         "cae1bed9caecd9718208cd197dd6b2cc70b9be07d50a1e1e4e219264538b8565"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1d4cf2b856caed04a8c09d73279e666cbde2b3da398b5f9d55b19ed160e681"
    sha256 cellar: :any_skip_relocation, monterey:       "083620d241c9eae053756e401374ec1de99952281e2f6a749683118cf5f82237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21b7c7af1071dd89150010046677707826130d65ac39cc7a41f69cd485f757f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end