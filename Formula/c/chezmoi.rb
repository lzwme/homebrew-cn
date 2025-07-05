class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.62.7/chezmoi-2.62.7.tar.gz"
  sha256 "d67af4b2ba35b15247f8a0bbcfd61147e05a2ac33cb67f403b6565837ee3861f"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "538c908ca5cb6da7592eb2846bda5cf8a1dc5041ecf01e742e5142ffb2901362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91cbb68053ae6f938120e4f03b7ccb9d75ada34c57b62d0b3520f5e99b90c5a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e532387ca1eaa6fb521885bbef0d55e93d9ed61a595f53bf779e185c8f1d0c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e222e0f16e7cec8674d6679d36492c8b8754cdbe48dc87bce32f3f2345c595e"
    sha256 cellar: :any_skip_relocation, ventura:       "30d5152c66d373de1740cbae4cbf08b3b36cd75694d9c47c883fc56906bf8340"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04ba79fe75d3131b4753991d1c4d9534ddb250b4bfe9ce22c22cec2cd9b25dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a78e9ae151d453f64a3039007abdee4d3af2ffe747fc8c7e86dee2c4dbcd96b"
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