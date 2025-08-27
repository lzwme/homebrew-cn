class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.65.0/chezmoi-2.65.0.tar.gz"
  sha256 "73ead3781fba3a7fb4e101bd2e1076ba7263b7a722e10635c858a8ed7b961797"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1645be6ee86c6cb54a9b467695ac82e05d84324e56633ec5737122553a1cddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a799942249c5224433c95b8abefbaf554f9fb854240ea57590c6a5ef800223dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e68c3a626ebe1a2f52f5c538b8d4335758e7411907c6f5141076dcc4f612466"
    sha256 cellar: :any_skip_relocation, sonoma:        "8408a5bf80341b801c5d526a8579de07d561c35fbad356f47f54015586a1930e"
    sha256 cellar: :any_skip_relocation, ventura:       "b0d99a40cf65014491c90bc20e5a5297be0bec8425b7c718cda226aafc5df1d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4925cd175d6393f28f9f8fe984d2d78e6ad82fe506258e5b4fb52397b2495863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3d6bdb30128114aab1bc982ec735d8c2dc2a0adc2a9054f0b254b1f02612608"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(/commit [0-9a-f]{40}/, shell_output("#{bin}/chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end