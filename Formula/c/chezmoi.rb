class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.66.1/chezmoi-2.66.1.tar.gz"
  sha256 "1877ebdf8e852cd070b99b09b553d397661d18c28cadc8384b7f4562db97ca9d"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca7c60bbe1bc72a91e8aebbb23fb32ba8b3b301d24961d2bfa375b3a2911270a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6ce463fe2a41fc0b68fbb1a89b7db396940f487c02197a77293f9b61f223bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d344847151e7834ec015fdbd2f830a154d0b35a35cee595c195ac7f4c622db34"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba72b5a893ccf80303f75c26b37575fd60349a15364ba43bb98848a5e9dd6898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e1ca12b2604d6be43dcbf2a27eb735c1b9812fd18eba5c0bce0911ee7681794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f2bfd05f45ec0c43018e4f617f17b4bfd6494f041bccdbd5ba1a594a17180f"
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