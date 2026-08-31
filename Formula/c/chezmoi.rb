class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.72.1/chezmoi-2.72.1.tar.gz"
  sha256 "0bfd3b1acb8417d5f6310c5fdf2b8ca9d647493586bf9c1bdb69df32cf428671"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "656cc5a24608f016f50fb0271a0c0136c3a6da30a7547a5a02a25a0edd47fa68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ce1b189f8e08a4d84798f125d6213ca0b3ecc90a48500cbd7bc34a804d26d0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41873563af6e875a86f03e65bbd3dd8383b851baa133d8274c96fb086e36a139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "345ec2df4c2a2591fedb3679745154a615fa6394805dc541994df6972904aeec"
    sha256 cellar: :any,                 x86_64_linux:  "33b28af47c14eb424e361bd5e201a5ce9bdb2dfb001c92d242ab12ee179fc113"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    output = shell_output("#{bin}/chezmoi --version")
    assert_match "version v#{version}", output
    assert_match "built by #{tap.user}", output

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end