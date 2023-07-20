class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.35.2",
      revision: "44814515eb8034b4d153569db86e58e278148e05"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b6a9b10712257cfb349d0c9ce496ade49e3cd0d1fd2ffdd355bac357277f9e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "030f6e0bcda1d5c9c85001510d10ba8d387d574f507a2b0b474fadd3b9e4ef9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19b260cffc2d091cec4dca687dd257e4950086b34b17e2db3572366c16b6b875"
    sha256 cellar: :any_skip_relocation, ventura:        "d8662732188f6c28e501386e7718feae61eaa15d18fba8a7d7bdc7217cd2e44d"
    sha256 cellar: :any_skip_relocation, monterey:       "dce5235de811c46b903ac14a329197a28323cf2cccc9221b7aa35f382e3c08d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "81f63e64e1cfc5da229e877ccc84b7bcbd355390aec4e6a5a66eb60843bf092f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb7a2726f3d265f2685c8330f22732e357873ca886147e0b0f6160bfe4f1f2a9"
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