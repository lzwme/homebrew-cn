class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.36.1",
      revision: "0b0fa89f612f5f885ccfc8c3890f515cc668c5c6"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c77aaee493406a53497e3d27254e3fc652ab2908395f9f66b789f481741186ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e4ad2b3b975bab16ea79edfad386f60a0cb557d07dc628b09e089d39b8c044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94dad33961a39e9368ccdc9872a6d18bc579dcda07c25d9d78475d191b4e886e"
    sha256 cellar: :any_skip_relocation, ventura:        "10319aade06641afed9aeb16a0c70bcf1ee6e6e84d78cb1fdd70450aed7d40ce"
    sha256 cellar: :any_skip_relocation, monterey:       "cc38c5c83783ec39055e55ab0fe35ddd1bdf0935fca66400d2c8f585b4075068"
    sha256 cellar: :any_skip_relocation, big_sur:        "2024572907ef2abf0b74ba3ee57db87ecfb2da0774f58fa8be0b61b48fed04b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4833db1e0bf0ea48c3791d3cc5857005cff80675229fe8d76102fb96e6afec0e"
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