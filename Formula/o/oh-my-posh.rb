class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.9.0.tar.gz"
  sha256 "c3bb16f34a8281c7fcf762993937f1b40332fa9cfd6c14546c590c3028d0c4aa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "892a94ca2aeceb2baae23c12086ff0a031ad88a3fefbde0480cbd94caa20e927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7e79248f1938a087c1e2734cea5303a3cd404b06ca885495336bb2df61e3c26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "516472555a43790baea40caac5c006e45f52317b8d4e6d7538aa1bf03e1af63b"
    sha256 cellar: :any_skip_relocation, sonoma:        "91af0a95a4ded49cb76b4f1e077d5d095b66109ad5146e86342477128b8a427a"
    sha256 cellar: :any_skip_relocation, ventura:       "2a71a3d486e1cfccf3b058eec8d25150808efab73b2b0ae585739b78ed105850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a767a10ff343cc4d77cc4638770c88f996e42ea65268885c9386196367a0ff"
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