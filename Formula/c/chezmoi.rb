class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.48.2.tar.gz"
  sha256 "49f6ab88240fea76b12c50e1f8a63a3e652a4ed48e283a0f89ac47fbd21a62fe"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4f945ce0c9fb6923838f9ee952af0e8a43fd96929f27bd3490ed8b479950c3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59b948aaf7dee8993429dc04a8fafd7b16d4004b35eeaf3fbdcd6a0d0a7860da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70d3b757c5c3e1f51b28d9c99f8e96baca2e82fbc0c75db0188213d3bb69469b"
    sha256 cellar: :any_skip_relocation, sonoma:         "94b5c43dfb9ae25207a00e266f029774f266005f536837453d49f7fcc13d3b23"
    sha256 cellar: :any_skip_relocation, ventura:        "f7de489bd70363767a3dd69bf39d84661b2feaa41b72f4eab72f3902b7389381"
    sha256 cellar: :any_skip_relocation, monterey:       "e2b9b0e4188e4ae19e9369244ead253fd561cf670608145a52861bb5942beab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85b80e929b979991ba9c90dbfa73c37c8e14744ee456fa7bd7ffed86c686be29"
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