class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.37.0.tar.gz"
  sha256 "d4a4aca01152c52c6459d3ca5adeb558406a23a2dd9b2734b331ae9fe2d0ec6d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc8bccea67627818fbe6acad9cae8ba03a9b195fa8606b6a302bfecbeda81694"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e9c4382f49017bba3d25e8d6d2895540acb25fc843a8f5708881d9a762bc7c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a9b23d57d1d9a79543b48fe122f7205abe786eaf45f6f3d92440b0f5ce21009"
    sha256 cellar: :any_skip_relocation, sonoma:        "73012d1d147f254286b317ff3fa4f3eaad59d1ba1e695a14722159edbf509ed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "420c85b25fbdb79110a993a8aa1f78abababb60ab58595b2e99a48a2509c524e"
    sha256 cellar: :any,                 x86_64_linux:  "4e8f9f6ed47a4eca81f565a0d199d2c3f8fba2f02ec55785bc53d4760e7c2602"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end