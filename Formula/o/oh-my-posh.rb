class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.2.0.tar.gz"
  sha256 "375698f75097414e54384193943c8968aa2f60adf9e407dd78939a7631399a1c"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c0181cf46e55e7aff948589461e23d7a1fa786d2ae6804ecf478fbcf45ad48e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74b21bda527a32e2fdd46a6b5ed7adf89669661cd2517d3559ae73ac34caa798"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3f0f8fdfc16c73c5cbf0db7e5f6f1e3b3c3721948a1d6b867a779c6a9f562a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b02ac336cc24450216b1487f2930462a7c033c8f2ba7455a136f863ca07322a"
    sha256 cellar: :any_skip_relocation, ventura:       "fb34e03c09cb5ecfa7f3f613e7f8578c5b8e81d3ed67bfda06b8134459ad87b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e3630425449da5db0244f963d4a47fd33692d679468ceaf3eb74f456d8dbbe3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
    output = shell_output("#{bin}oh-my-posh init bash")
    assert_match(%r{.cacheoh-my-poshinit\.#{version}\.default\.\d+\.sh}, output)
  end
end