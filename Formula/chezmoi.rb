class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.33.5",
      revision: "a06f7661068cb258007e4736290d2b80966f2525"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a96d2dcdf84ec79e7a1c106738f0c2d6951e3626b316bf09ee925aca447e4cee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d52887052cce0b4e12d1e7cc318a82da22734ee8c7217517fec13f0756b5b98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2214082896f10cc17a6be3eb4581a55ce71dcde4267e71dfd9dbabbd3ef62af9"
    sha256 cellar: :any_skip_relocation, ventura:        "c1e6e23d7e01ddf0ecb83fcdae5b87a9dd1ced6a6ea4b9b4f0d9124f0ca07f52"
    sha256 cellar: :any_skip_relocation, monterey:       "6d13bb2f7b5fd64b9c17b693cbbf0685a7e2eaf7a434895dbc1be728e7b4ce08"
    sha256 cellar: :any_skip_relocation, big_sur:        "b30f10117bb6ea799d0c3445da6ace24a4210b9954c9c362d842ecff2328e9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "621e76f196a70b7ec8f047b60fa8c575e309f79daf667a8510695ed895950407"
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