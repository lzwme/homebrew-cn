class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.33.4",
      revision: "b9603835e602a317d4cca08a903add9f8713e88e"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b87946a3d5a18c817ab119fcd59d7d7dd712ff9065a98d0edc165b0e3d9f458"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "595b980a74bef85c7df34af59d7cd18de5544f867a87bdc5ce4b808ecfe65be9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0054b879e8ce2268025e7eaff3490cb324a31880946e58cd045bb2acbb1102f0"
    sha256 cellar: :any_skip_relocation, ventura:        "09e974edaacacabd513a0723c49e282c9a02f91cc5b1d6ba39f15d257cce101d"
    sha256 cellar: :any_skip_relocation, monterey:       "fb53745ed2d7401de71754d2c93f033643f00e4fec5b7b304a1acecbd92ee536"
    sha256 cellar: :any_skip_relocation, big_sur:        "55664ce467727acd6169067dc0bbbdc8e18205567dd1079f635a953ab0d8a549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70683ff4322d347aa3414ccba72bb88d151c11209bd49b8143ebc8734a904147"
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