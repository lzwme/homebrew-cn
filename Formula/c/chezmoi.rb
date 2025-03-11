class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoireleasesdownloadv2.60.1chezmoi-2.60.1.tar.gz"
  sha256 "38ba72df91c16cbdb25302e2a1239f7b72fe4c4cdc0249d79b1ad455271bef99"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abf3302817af55e75ef5a771c6bd768a5004fb1faaa9638c6bb72bf8a6ad8fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "514c2785832c0b52c621331e106fa2b98fc84090cc99977b2b39bb498c57989e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e037fa61f48622922f3065f48fa6673d4ba4d3e856a123549665d1a0db7b4a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "f66e5753c19521eaea68736dbde27e88b5d498074e38bae5cd56326098b5c724"
    sha256 cellar: :any_skip_relocation, ventura:       "43c312d08d5326a49f745df7caca0837fd0a5fbfe3b09e9bc3deb2c8f3dce4bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f63a034e008cd0f522d97c0b2493d84ca0fdcdb8a6e4ed7091fda10afc46ce9b"
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

    bash_completion.install "completionschezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completionschezmoi.fish"
    zsh_completion.install "completionschezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(commit [0-9a-f]{40}, shell_output("#{bin}chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}chezmoi --version")

    system bin"chezmoi", "init"
    assert_path_exists testpath".localsharechezmoi"
  end
end