class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.69.0/chezmoi-2.69.0.tar.gz"
  sha256 "b9d8e5955ac58105a114f4c5b5c0e508fc5ea5ebaa2bfb9eb2276a2cff161c8d"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "813dd6160f5b7fc67b44214382a232a32a3b353a227e1df0e8bc1ab829956b9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6dbb25f79b99becfbd3ec5cd9795c4490e5498d21d3a430c4fd5e189d8d8cfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4077380a32b240eb32c29bdcaa35a9af29255549cda9680346654c09999bd6a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b6dc4bf76f5b1e0faa5516603f91ca58c33f4a07ad2ae661e9190126e46bcc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d726bb5fdf89c116223a5617cceeacde83600a7f034eb982fa610a66b1bc132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44723ca478585aae560455c5521237dedd45d0baf2cb42528ca56117c63c17a9"
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