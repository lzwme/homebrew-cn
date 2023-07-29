class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.36.0",
      revision: "be6e90307f9b5c8fa5d356183418a16d7bba69bf"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2baad2bc7c44c9e9abdc726896e9f8928f2b0ba780146d8bb1d849938ce6007"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee4cccf040af509c773f63319d40f1ca7beed3515e96b335f8664c3115f79ebb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "512e16ee3b20f948a11a38f580850a145ba544b0240a5c00c3ecc5d4cb3d4ed8"
    sha256 cellar: :any_skip_relocation, ventura:        "0eb13d4db558ae7a2c453c0a52de662330d9eb5c5e4c119c0fdd888d5f17b275"
    sha256 cellar: :any_skip_relocation, monterey:       "65af66c7a8e9b8b178f37d7c1a76b78a2da3fd028cd9737739729db6fd29aefc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d642ff8c3ce8b52e1f643c0088c5cb5a9f05f6a017954c7dd523c5fe62d48d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe731821a181b875fc8d89dddf8879ffb8317b70d832da3da01a9daf2410a3fb"
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