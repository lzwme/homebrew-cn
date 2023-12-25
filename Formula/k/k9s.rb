class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.30.1",
      revision: "f0d0e62b700f08b04318d5c53ed0012ef2b0c8d9"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5442625c19573633f8c8b1f73fb4c1644bb1a56a7fc13c56d46666be6faa3294"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff7e54989d511e6fbda3c42a2dc1abf8bdde151e9883d862cac63eaf7787b145"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d422d6f8f7d70041f24397b04c1ceb03c4ea8ab3ed0234926eba30f41a18a1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "adc5b97d296aaa1f3106d5be858820f871c0d2793800c9afad9ebb89f03483a7"
    sha256 cellar: :any_skip_relocation, ventura:        "7d42e57a1f8728ccd6e07f19d89aff7babb74bc21195dab037c1356bd7203308"
    sha256 cellar: :any_skip_relocation, monterey:       "e7e3cfafdec9c7bec32cfba5e50c71866ce998d954450c556963bdf7d5373657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f114f4314b04097ca215c410107765979c2c9971b8017ee6aa462fa3bd146cb"
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