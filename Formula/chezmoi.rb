class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.35.1",
      revision: "13fe7a9660d57ac348fa62caead682b03a163699"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23d177ce3bbea37aae6a4bc6a09ec85b519217e6ea68315ae9aec2906f01b168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92124005c1046cc2d18f8169f7f24fa9eaa6d89cdf12cf638f9cdd70e4a80eaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2204d996fa6286e2136ade98f3718fceb5b6ce2f3c98bdcb55a82b529af7bfb4"
    sha256 cellar: :any_skip_relocation, ventura:        "fa46ac595d175bce0c918a87a8a304c9d694f30f5fe0f26c4356cd273d69f8ce"
    sha256 cellar: :any_skip_relocation, monterey:       "9aa83091bf121398d7bda5eab39755390d46f99189e5b4f49fcfb66cf52cac6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "29383a70a922880190202786c43597393e461cb891d097f21a731b8385c9e46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a4b252b9603383525f20b84c840266141157a516d6b002562265c2ef06414a4"
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