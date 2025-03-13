class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.40.8",
      revision: "772faa52fe2429bb5bae11d938ee2a6c52bbcda9"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4abe3f0fa0b70684d49812e595b381fa03ee01ce01964b1b77fd2f70b56206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9c04f55d64c98bd3af4b01ce354158b5059bd3f9a5e51bbb06f80ecc401b8a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea626059a7a1dbb41ef96fb12d767653f47f73ef20fb195579f33d3c56aad698"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f61fde8841a91f7591e85e8096110a827ed86790abe27ffad40b08f6d3b2367"
    sha256 cellar: :any_skip_relocation, ventura:       "1c1428fee39e45de78ed2696fe809aac4ccd477b742a447b04aced812be4ccfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f7c048293c31cf134124aed66011aa18564f82fc0b4b492a00e37391dedb72"
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