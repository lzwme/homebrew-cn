class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.68.0/chezmoi-2.68.0.tar.gz"
  sha256 "8c3fbcfda3667f6ec66a133f07c9b99402f84482b888af323a90e9985aff8bbd"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7e3a93f63a8c78c7200ccf8f04f78aa1785a0051fee25bac2aa9aab2524912f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e486ce776d7a8e2310482e68e421cb574520558d88a3df1acb3c71380c1fbca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a1bffecd7d098d8a90b01bb9c5a50feaf7389ca939e20a35c26aa3574e886aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe26455d536573b46f9ca75fcae44395353658c53298e14c4eebcfde0946b84d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2489329af98f8333d05363637891b1ecc7900bd8f28f384eece3e788531f1c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23ccc73b0ad847118da7f07a23e07bc7b48efc53ea35e1c373ba799958defa55"
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