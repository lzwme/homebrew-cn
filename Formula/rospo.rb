class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://ghproxy.com/https://github.com/ferama/rospo/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "27c9979966dab1f0fb52520f20edf15eabb756ddf1720e88b1fcec5b8b3f9656"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a79a90cd3e485068f23ef5b3c52ab3fb8e3a5da356f085ce3fefac8acddbc876"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a79a90cd3e485068f23ef5b3c52ab3fb8e3a5da356f085ce3fefac8acddbc876"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a79a90cd3e485068f23ef5b3c52ab3fb8e3a5da356f085ce3fefac8acddbc876"
    sha256 cellar: :any_skip_relocation, ventura:        "55e33650345b5105e19cc6ba476404ece43c589171b740bdfb84809eaf1443b6"
    sha256 cellar: :any_skip_relocation, monterey:       "55e33650345b5105e19cc6ba476404ece43c589171b740bdfb84809eaf1443b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "55e33650345b5105e19cc6ba476404ece43c589171b740bdfb84809eaf1443b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f98b7bbcb4abfd84a2b22c1a2107026377aa79d2f2b3adec68bfc8ed5b29bdb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end