class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.64.0/chezmoi-2.64.0.tar.gz"
  sha256 "573b9ee04e9415a23f39a314a74bb574832dbcd79edc158d757aa80f40137376"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b986eb134f0ff857a9fa73a23a8413120fd2dc25401eb7d0d93d768d19fc78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1899410501ead07d6208251a19e566ab23d0549ccadb4b7237982db2bb9dd700"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7eacb9859f47a2118660c789829c1f00ad8711372418795245f5cc39da21d8bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6be91d35aff42771f7e5774304bbc693dbffb9cfcfba5f9ce7d26778bb931292"
    sha256 cellar: :any_skip_relocation, ventura:       "3d98a3be32c8edd6958468acb239848f3f6e74a258056ef1a245f1f4534b851a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3d43b27931ab47e9a212e28ee4e4888c4ce65e4330e0984a5afeab6a167e987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ddea7c57d9b747fb5b2f6cbb81dcc1625f78f4de66754d57b70767e90c72f2"
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