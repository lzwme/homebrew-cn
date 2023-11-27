class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.42.0",
      revision: "694977b904e888ba285aa0fd44617d1d59d89bc7"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72c65b2215a3faf197602d68727c10d7eb75bcdc667baa8c4a7a460df5f11b7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e8ed8ec26102b8891f1e3134a5df3503ac86a7f2d749dd45e391e1d0114746e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6506b9902d37d1f8cb83f491f59907748f824d399e28a9a45677da0395e6bbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e58ff1b0927b2266d8946fe60ac20da4ad99270c59fb914e243f19ea012c1c22"
    sha256 cellar: :any_skip_relocation, ventura:        "87b25f03527683aa7dbb1adc551883a25a74eaa51d6c8bf8fbabefd6cbbe0ff4"
    sha256 cellar: :any_skip_relocation, monterey:       "79e23e2180a7a750bb64b124bbda70e6c90bbb2210d3945f87ee21c98de191ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2442d16d7feda3252bd43e6a300efd3008b709534114e892f1ba16102149546b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end