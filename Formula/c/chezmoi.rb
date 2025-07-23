class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.63.1/chezmoi-2.63.1.tar.gz"
  sha256 "95a55cbecaed1ac1a0f2db7690e6b13e1c801916dbef7e342e7f750029c7b96e"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1425b3dfe0040116e0d748d0e1d21693fdfc827e55503c9077603027d6d42ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea96ef1a76ad83380f90ee158d45e6eb3855b75e578e7d8bc73c714d65340401"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "363dffb9ac801420d9dc3bc39dce9f2c9d650c303c7b8c6baa557986f66823a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3790736942ff60ae382bfed3bb237c04d18abfc3e6bd5a573e26e057458c7ff"
    sha256 cellar: :any_skip_relocation, ventura:       "67be1d72f74411c11fb01e320a11eade85e30f9ff9fb6269d3080517382d352e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cdbe22d84b0e58b8fe9ac49de34bf588c1a88dc4d6c5c071dc42a182c032b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be2ced2d5b516c898a61009df0fa4bae58d88173d9e1b81e412089bdfb7cea4"
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