class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.30.4",
      revision: "34da44b441598c68fb6de1571f2a38f74d66bb01"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76a1abbdd5a9fd003126ed0f82e935c3fb7f557728658128bbe8c51efee23902"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a796da08d3deb1833b093763e7d2d5209420f5c0c13fd6279d33b05b554b775f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3b6991a500e557044947823736d583e1e5e03c36c05ee8213186317700effa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "83092716021af18ba53b8d25abbb433581cf04d9ab3c0b351a9d6f2f4037dfdd"
    sha256 cellar: :any_skip_relocation, ventura:        "5984c9617e0fa5674265b93e1905f8bb6b80f66c900913b9c7bc2f4f6b9dd1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d9856495f11191141641068621bd1ff344c7a6c4b8ddea9090b94fbd56b622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aadcfec9f52f3c507f57f9af47d0412e24a5a180dbc310c1c718a9087b05d1c"
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