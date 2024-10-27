class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.53.0.tar.gz"
  sha256 "ab20a0bcdb36b65a5338489bb9c6828aa336ece966c0fb8aa44c1387cdcd8ccd"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7c2c12c47a9fa22450def74d9e5153b52072c8b915a133e8de7057fea01526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e287c360e1245580bbcb3b543c8de53720f9c622e9a875591f3bb98dceba5f49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d28a22d2b13cc5d81a407c649e02ab9d8ccb166290e2349e53152a33403678a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c3d35d93a818eeabde42eb0eca63133e73e94d882532404f9cea467795b6c77"
    sha256 cellar: :any_skip_relocation, ventura:       "b34ecc6d186be8861b220b70d975abde097dc9b8e0a24cfad4945f8c779e4cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b0ef929672e16480d7b5aafff2a27256d7ff272d53883f1979f215f1ccef117"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completionschezmoi-completion.bash"
    fish_completion.install "completionschezmoi.fish"
    zsh_completion.install "completionschezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}chezmoi --version")

    system bin"chezmoi", "init"
    assert_predicate testpath".localsharechezmoi", :exist?
  end
end