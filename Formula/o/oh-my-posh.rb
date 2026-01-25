class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.1.0.tar.gz"
  sha256 "1bbaafbef7b4e5d07528b391e7fa3396026ac29d026cfb18569a8b3c027bd5db"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6608127fef15cd07f9b51e3f69ecd40a81135b466aa1f96356fe8c810491347c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b39667c030fa3bd0b402107664f8fc8862f611811a34efb6715072819b96bbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80794775d57e2a424ed2cad686a3b8cf37e1902e1da4e6a85dbfe9cd32297e84"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5a87813edfb43368bcad10f665e81c07802a04ccd1c1104c79534c90114bb9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8187401696330f26834dc571e20e2b6baccd5c55bef9847bdb485c3448036f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa7ad197a78da0b3bcd15e32c7a5972fed5d92da48a770221d938dd07d035ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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