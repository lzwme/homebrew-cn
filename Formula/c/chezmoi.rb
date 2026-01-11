class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.69.1/chezmoi-2.69.1.tar.gz"
  sha256 "69e6570b034ebe877a691b19bd3b0d581e32034f9163d6553ebdab5ae5fc12b1"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3c950e5aeeb48d46d5006a57e73a95db6675ebfc68356d212f848c45b5d6f5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "084817df3085565f1c8e3150272731f0da24097079790f34bdfed40cf24994f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00e164344e9ab5e98618c3fc861060dff386fb0924b9b7aede4a5297a98aaec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d9c65daf25ad728f9e6b0acd684827296c1bfe55f016f33c42aee03006bbabb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c0d0eb97cad8b9ce55146b711bf5c06166e040260e7dc9de9e608d73e6ebddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d563cd9b8ccba2e18178f008f22e1976ec156f51c06bae011e0e65b146e13863"
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