class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.10.2.tar.gz"
  sha256 "789af40331e2220f4429a5d13d5854189ace14c60f56d232b100c6911713ad39"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9108ad188bb47a18a93cbfd0bc5ad5559e7fd7b92d53560a2f9a6f0b6cc666c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41c0d62372deafd83bb4ba61ec63f8f887c9d23836da1c35e4b53a6ecd64d21b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bf451dd8718a42a6f5bd82f85df7fdfc8e58fb60ad59011cf6b242590f170f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "75c197074a375d357740cb065c4f502611e50175aadb5e396748e2d376dbaacb"
    sha256 cellar: :any_skip_relocation, ventura:        "b76006af45de516b03c98c8077d48d95c051193d832b00866eb65e968d36abe2"
    sha256 cellar: :any_skip_relocation, monterey:       "0351b6153ee16808a9dc01561635ea09bf952e9e49ebcb657c4d4e3aaa4476dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "342d8f2ee6a65dcb7a406f4133acb12fdc42e7f8e9fb8e6a28bedad3799dbdbb"
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