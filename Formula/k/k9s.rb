class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.40.5",
      revision: "af8aa5fc41b3db202941a264a3011f490bede97b"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c14e6585844430600273dd5836ae266c85798441a50d2fa292af28a3c019076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8170e24ce41930bcebe9e725c71e1f6194042f3e370ee53c0d2e6d8ca1848f36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "222227bae777b50620ce7754aeba53394110193ffdc664b6874b9354da6bfbd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aae6acb453e7619bfd21896b43fada0df088e2fa1824d1bb4e8f71c73e33984"
    sha256 cellar: :any_skip_relocation, ventura:       "9705e2ae5181943e08331f03e38d2766153d430b625ef95976b7301d410487cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5df32ee3b3597c5982373bbfe40c0135cefcbd9ecfe8d9e7fcaab5dc0a5a3a0e"
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