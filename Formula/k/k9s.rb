class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.31.8",
      revision: "90a810ffc2ec5d5460ae4f43325e295f158dec65"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2998c2a8187fc147dcf776c055123ab2c877dcee04e0ed523d9bb1f5924039f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74fe71b4b730c62b96eda6da7502546c312500b65bc81ed8477901cc9f53b34e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "380149a113115ad4f09edafee82b17aed3d4e29c8570a9b6769e0a39f40de1a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0a11eb30519717502c8918730dc1434ec157478ada13387d83d48e1566906fb"
    sha256 cellar: :any_skip_relocation, ventura:        "be9c3c388315423bee8775a5504458e7b5d35bb29e1b211964d5a2574d037266"
    sha256 cellar: :any_skip_relocation, monterey:       "7749f46015297fcb1be863578817102b90dba297baa3fd33ea42c49722457545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d715ba819f151fa5dbe9037ddb17ddd2e88993d21613ad486d06ad8ffa43ad22"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end