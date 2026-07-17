class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.31.1.tar.gz"
  sha256 "33a92dfb5d5c5dfed3236802c7b4cbebbfd64a3a43d9b7113f7c4cec66815c0e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75727a855af33e853eb433a73c80e478ba5cf3fbdc8b988f89730ca60364eb2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec8489f3cc8f38e4c385a42623da6ab75b70e36455b525e4a36a3de3992ca586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d190e065b26750b96041b010abc5075ce2aef6ac3c142b351b6b8a6191f342"
    sha256 cellar: :any_skip_relocation, sonoma:        "cce2116368543c3314303e68567a759ef79e742a9640bc15ddcb4d619cb1ca6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "347d5875497aaae4d309aadf8f223aa1423c2227fee718b1601c57f24abb5e05"
    sha256 cellar: :any,                 x86_64_linux:  "1a378ccbefbede5ceaafd35141b8ab0e229b34ea30e0491b130a764257d9dcb7"
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