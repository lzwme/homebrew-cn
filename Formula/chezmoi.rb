class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.33.6",
      revision: "5bea2f925fc2b6fcf2ee116a20bae68869746787"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3c9eebb7e581792157e59091a03a301cba8c367cff847d8b59d8935d5e855a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "196fc2c48ee608def17f87d234f85d48f08c70c405df388307a9f146d7abc0a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af4ee5a30063f3675b079c04107b8bbc991ad502e6178dc5fc2f0399735e29eb"
    sha256 cellar: :any_skip_relocation, ventura:        "ccaa31575a8253ba8719f5c55343371e42738774ef2dd9a6f824b760be9501d4"
    sha256 cellar: :any_skip_relocation, monterey:       "2be4e8013c2b499386f3c8a50768bbb1c23fa30ef5dc11b9974762681ff404a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "709ed7b53ea5a3fa3e14009dd460ed366327db5ac79fbda1cac90b59ac318a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c7007b3b79b415e92e1eeeaadad901d55643a949f53496589f29deb9ca7c9fa"
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