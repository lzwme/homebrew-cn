class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.1.3.tar.gz"
  sha256 "8899edaf6df046a0510f26219324485bd3b15517855c35c34bd7be799a98465e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "830f70cfe8e72b49e0c3c3ada09b7041dc0f7f5974699fa48181e43564b1ea5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28dbc570ec8b69c2a45e201d633276d4d5c7ea0da087e7b1a6c22bbc9400a2ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccdf99ac98af4b85cfc0223d9a30e5b625a18c497c91662cff55407d91aca728"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f05b72e1164bd88830ce0c59cd0b00ec23e5e91d4f87c7a7c48ba7325ddcdba1"
    sha256 cellar: :any,                 x86_64_linux:  "13edc8660227ab67592741e795694cbffaa95179142aa3b7ba4dcb5f64c34e62"
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