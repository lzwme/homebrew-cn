class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoireleasesdownloadv2.61.0chezmoi-2.61.0.tar.gz"
  sha256 "2ce8f58a5fd17a9c3b94926976d4cf263b864a3678f9b0d1bd2964eb3902ea7e"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfeb360e91dc9156c9ad8048516c141c7c72c28ba019d62ff09ec89e90bec3d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f2b37962127633f559eee96afed5a404e450e00e15a704856616a786e500c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0c3bd0e759df90ffac0b80532f65d596dde2ea48a3cc978461d002346acb523"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0d359dd54fd90109d276c91e21aa17310fdbad2e13075e76f733ba64c5817d"
    sha256 cellar: :any_skip_relocation, ventura:       "0d786e8741398d52c5899bd31b3ad26c33bf5441940ffed46e38a9dd5fb0293e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7136eb17ceb19a38ccdefa7c9cf5b1c4b2a68eb653698e94676462c0ea40e21"
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