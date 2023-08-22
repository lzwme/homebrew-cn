class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.38.0",
      revision: "0ce82b3a958191ee441034ee78da4b9440b51dc0"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67f1a248a03d2a48dc37af1785377538fe22403733245ea83bd3fa6827f17667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a458ee6f05d1337fc6c64165feb53fc73376f1143bdd164a87e0f18ed742117"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf8dc90c6bf429e732a80b3997b876d8b55d57db66bcb51c6a564a1a5e5db647"
    sha256 cellar: :any_skip_relocation, ventura:        "1e70fa0374b09c0f63eb54c34748e9dd8d7fc2cfcd47632c46749ee61181ee9c"
    sha256 cellar: :any_skip_relocation, monterey:       "1d7703934d9466a6ab36dfba24facc81bf540bc8a346056e9f49169417ac9b6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f8dae72dfbe3340c10d3ba52cfcda93a27d1d10ea938d223de789261414ea09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64f339a00dbccccfc075131d5370a6b84310177fc49eaba7477ca333d5e2ba9b"
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