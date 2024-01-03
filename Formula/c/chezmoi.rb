class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoi.git",
      tag:      "v2.43.0",
      revision: "a450748cf0f672dd09cdf933c21de4e2049e45de"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6f9d6b452092dda40511faec90c2705b44d5914605d246aa6ef21585cdf99bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81b1103b0eb42150c3a58ac89d19523a5fc8d21d7e471b16f5c528509c04fecc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e435953616ce212e4a8435dc76f2fc99c43ec0bfa882c7cadc8eee219450e688"
    sha256 cellar: :any_skip_relocation, sonoma:         "f643831c92d9b1b88af868c538ab99c2f8a3e0517ad043836b154a7ac4b0058b"
    sha256 cellar: :any_skip_relocation, ventura:        "34d4a06985cbb48dd3e598a8dda33068166361dfdf6b8471183a50d35c45e34d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c633c528919e5817e54de99e9cf057fac3664e03cf162b80e2792070f44f66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "629d9bdab81935d9ef69728ca2a6d29a3ab52a4cae7c46c5979f822237607724"
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

    bash_completion.install "completionschezmoi-completion.bash"
    fish_completion.install "completionschezmoi.fish"
    zsh_completion.install "completionschezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}chezmoi --version")

    system "#{bin}chezmoi", "init"
    assert_predicate testpath".localsharechezmoi", :exist?
  end
end