class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.42.1",
      revision: "0b38793c15f3fe4785a58b6df9796d1a6cf8c79d"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3042e8755eb61c22c2a2fbb5bc1dabfd027510cdca7de74197119474cde1b7df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "891e44b1f6a82fce5768076be753bbba4bc4aebb5b902ec3e876eee7a8e19541"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acb7e9c9acd809da3343dbdb3900a6d487ac14640f833df9c64a8de18d6046b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ad36110dc4db24a598571406cff105e2c2ead28f5070c7ee086ed4bc5ddbe5f"
    sha256 cellar: :any_skip_relocation, ventura:        "e48a907e1a7107587e57a6d3f7f392ec3a4b66b17acdbd77e85b415e365724f8"
    sha256 cellar: :any_skip_relocation, monterey:       "db923dc8d90b35908a4a0189bf676923c6ac122de938cfd7bfb9e4d012329955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5051bc7de4c217606f7299082bb1006ac5189e75213610228e0338f22177c0ee"
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