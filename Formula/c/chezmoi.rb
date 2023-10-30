class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.40.4",
      revision: "97de3c9738828f6f5c2c282b9e8114142f07edb5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e7735989651e3a2e5f6c915c4eef02aa2c9fb55e6f911f72c7ae71e1347cff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecebc44a8080ace360bca37a74b66e71169c56a0e46d8f30f3531bc8880494ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a243e90b0796853f1bdc9e40e8084661e0a493ebfe71da09366d87ebbe541d8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d7f52fef2ba86a9a1687d7d9abaa1d57e3dcbf41c9a6b0da6a36258ff00bdb5"
    sha256 cellar: :any_skip_relocation, ventura:        "f03a8b0054617fbb4e5c836bf640ae15a3b40490606665ad54aa6e87b128de32"
    sha256 cellar: :any_skip_relocation, monterey:       "a389237318789644ba2d09bb811e703b668de0c21a5ad193895cd8ab429c0364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8fcdd5e72a6029d49485555dcab43329deb17aa90e63adbff2c2eca5bc5a1cc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end