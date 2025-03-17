class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.40.10",
      revision: "35361bb23822761200fcc977653818faf054adad"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91667156ac12eaff6f4a7de86dbf22bacffe2791008f1e64291a13f1fa735158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85d934e96fac226b0c27ee890f3351956648b636e1f189110361eae44932d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e17ad445c4d3dac501988b5d4d868a1d820682957d534a04b9ea67ee1de9413"
    sha256 cellar: :any_skip_relocation, sonoma:        "75b2b259d19c28e7ea6d2562728cb482c44e0ea867a71609b5942047af7f2b2d"
    sha256 cellar: :any_skip_relocation, ventura:       "cc8ad51870fe1e5309c8ba8fb30404ebd38e2e3568eb27f18d92c19d210b5b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d96d78bc2a5aba7708d97d07ed1f1dd37f15b70590ca3e44aaa72f001330fd4f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end