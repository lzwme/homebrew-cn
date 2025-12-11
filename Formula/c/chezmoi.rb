class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.68.1/chezmoi-2.68.1.tar.gz"
  sha256 "f04377dab28c0b3dd0cbd4e2671ab86120f7cc6faa1ce8fa6daff69bc8b456e4"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10907b9f0cb336ca833b3d2e74b7ca1f4301e43b55a51caa8e31267a48d3e8c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c8dcb1b7ce55498c868783b39e221fe6df73b7905c278d3317e28c9cba54f18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a7161c5fa605dd18965ca2183f1366a99f678a341b0757918dc68cc2d801c1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "28bc829de27e9bee11bb655f3ddbcceb011c35f570775d2516cdbcb6201db085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "162c5dcf742e00fe53d67702d54fc45ec9fa7d47033cb47858103bb8f44cff86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e9aa167622f644de3d17011bcd71405e7c74cab2a5a0170b2aa45e477ba385"
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