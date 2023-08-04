class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.2.1.tar.gz"
  sha256 "0690497bb5badb33bc5cbe053678e6c235ca1e6765c490bf4d2a0b7500ffc5aa"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e73ab73e622baf5597cca154de5a20a91e73993dfd22723d53ff6081473d7db3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93db3264daaf4e21d68deeede51b5cb133daa0538b44d7a4f1654942fe9783a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44117fa975acafbe1fd7550888f95f8962219880156e1d42569f3dc99c26121a"
    sha256 cellar: :any_skip_relocation, ventura:        "a3c71bec03d5cbf00f9706e8ca5ac11aba33de743de962c38bf6144632257ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "91c3b252821593ac05c8cdb7664842c97523f345364f3fe0c850176aeae47897"
    sha256 cellar: :any_skip_relocation, big_sur:        "d458437a57fa82bd0f4735bf8cbcb6f98c2b36df5173d9e123f5800e103b33be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a3056162a23071a42c92751b0f02448122fa48f998566eee0581db962fe59a"
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