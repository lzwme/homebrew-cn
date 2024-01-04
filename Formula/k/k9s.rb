class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.30.8",
      revision: "d0f874e01a747d8851f0751e2fd7677266733f7f"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b52ec069ae7b3c1f6674a2d263c17e7eb14ab0834d3ba958a53e80e0ea5c062"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f6d996fd19ae895a31e48f00ca070d4e9ac82cfbb876e5184ac83c788f45fa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7dd5dc97f2a61c7dc20bdd032ceede245c23ffb48294a21043e8863f5aac9a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5182f4bfe82190004a0298bec7715e5c71ba92c5fb94cef76719c184ae7adebe"
    sha256 cellar: :any_skip_relocation, ventura:        "984af1214cbac147b78fb9276069bca20fcf018c00cdf73da79578bcde2090ce"
    sha256 cellar: :any_skip_relocation, monterey:       "bc740d34fc21b4fe3598b627cb731f3f166d52e24b54c8df48d1e76a82d6f1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bffa6b02764cd5aca331667235e4720ffb278777c2f7c54d622f4547b47d306"
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