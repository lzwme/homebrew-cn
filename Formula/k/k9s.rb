class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.40.7",
      revision: "08b8efa6179dc7d45daaf9bf748585e6466b198c"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "841255310cac94e5b993e8fe04ce4ab65401f12454964a16b5ddb0d9f92dff71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11b0ebcc140656bef5fbedfc4cf779b93bcd978dee9932c8eab014884bbb439d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8802e2ed00154bbcf697260d58a7d7ae12b4805a363c63b267c02d308fb7d53f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfa2fcd3a142f9f01b184336f0bbb77d1f95aeccd4120c9dd33755e4f99a7269"
    sha256 cellar: :any_skip_relocation, ventura:       "938876b436bd7ddf16c5b831c6b00866c3b8a59dae28774fffd1a1ea8d702054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e50c607f02026fb099ac77c659cb926564fa2a88b2b8f8589f59d3f9f181b1eb"
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