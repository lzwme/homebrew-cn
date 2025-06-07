class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoireleasesdownloadv2.62.6chezmoi-2.62.6.tar.gz"
  sha256 "99e7a98b650f617fd373efcfdc8b09921af44d0f59409e1aad5df6c5f19f350a"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1c51436df302126476bb3cc1b750a25f4d27fd7e7388de722f0164c84fd70d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53900423356abe2174773a50d724b54b7765b2d9d51a7dfa0c3b03c444d8153f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "855ed4b8da5c698273c5ac8c82f66e6e8c44671f3d930316221fda7c7ec51d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea083d8ca4b36991e5b9cf2b7eb7b4dd3246fb3cb8c4999d8b6700b2e9b40004"
    sha256 cellar: :any_skip_relocation, ventura:       "83d065f14087171582ae89e2a20d2657c007344c43c837f0aa06359db3b0d96c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c329ff8e8c7832be21e1ae97a16eb1d4592ab266fd8c62d706c74f964a5391e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bb10af8d3a82337246730c7e9e52ccdf86626d41dc371f94fba47d1383137b8"
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