class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.66.0/chezmoi-2.66.0.tar.gz"
  sha256 "04b6f079b88b03cf76dd76f81bf9c870aef6ae0b720424d853f106b1687466b3"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86b150ee9179099f3eda277e467e299e433f722cc6a625dfa7280813c9264bd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15a84e85978d7ddfa3b6ea513d8bc03abd2da92cb3f1f5a832c4debf18f565d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42fe1acc98d5d765a35ae8deb573b958620f31bd891edfa0935c1dca6f5d0774"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f0e8430b6400c7a42c5f32647c380928b05635b8d23a7dcd146cde96e7c0edf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d94ba52b11555d0139ae31c16295658ae42ad55a459610beb3393fa484575dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d3c89de8e69ef3e6df3c3aaf72791b381d55694a2503f56eff0f0b5992c04a"
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