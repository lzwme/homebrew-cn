class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.26.1.tar.gz"
  sha256 "f05d62ed300b6065d88b3fc6eb9517159313710434011d134089845da3f974f3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20394f1532e30ef10e95b3125682b747f674a8b8aa65fbd1b7dface4ac60ae52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56cb90db7e9a7488f147e457576c3fd8f355fbe6489ea17bce8c4614fab64232"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a136672df300a65d5ab623736a3bac1c71902b59552f14d64e90da58b4628791"
    sha256 cellar: :any_skip_relocation, sonoma:         "63a7fd8eeb3e39d9f66b893ff72b6a2142652961e4fa266c62addea5fc632d02"
    sha256 cellar: :any_skip_relocation, ventura:        "c87135579162d3d8d24994f35f1aaac6857ae908fa549fc5f155dbf7b7de988c"
    sha256 cellar: :any_skip_relocation, monterey:       "775a674585b51f23384c9e073969d8fc5960689fd4bbefa50ba6b88e1c0e3f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bf7cbb71e02c5d8f44d3f118ce119fe5a566e33805c9fdb6c5e98b0fed657e2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end