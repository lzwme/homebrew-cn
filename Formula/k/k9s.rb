class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.31.5",
      revision: "ff17fff2861c02d325fc95d536d3787b83cb3782"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f72e5a8f7ec896fc19e3952de51fde8dd0d30d64c9a4c2fb2e8e127e8577eb20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18672bdda45621f63d11086d27f6624c8fd56a5d95edd8fa8de8c1cc308dd0b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "683d952b248a379883b5a404990150ac7dec342708c4cccc75ff3188109dd3f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f0814659c0593435ca9cf2ac2d0d6439ac877a3e9308f4a475db5f9d4bcb9d1"
    sha256 cellar: :any_skip_relocation, ventura:        "d9b701d82fc18db0379a8666ac9408d3603882282aeca7401a30047d3da65ed3"
    sha256 cellar: :any_skip_relocation, monterey:       "d902b844250669b95cd181732cc11e94da06bb96533cf383b4a7318d0455cb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144ee386c082f042027b14d81f2ef828d68ff24e9891591b4078a1d7c05527f0"
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