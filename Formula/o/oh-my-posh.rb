class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.1.0.tar.gz"
  sha256 "006e5eebe43db8ad670ce43ce457ff1a34dd261005c6cf0900540cf85b372702"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e1d4fea4f3b8927310739422b264378ac211fde638fcde40a23f8ee87937baf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b889ea2e4e8252b117db2c888469845ede6d835c3b0c21fd3a9845c43d734ba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1017edead27c0ab148031c25a0ea9776ceedf97de4e67d453aa264ab6f99148c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc8a81ccaaba0fcf890dc1ed6cdd7c2e53a1dc61f443d5ab60799e9043898e52"
    sha256 cellar: :any_skip_relocation, ventura:       "1e2c4caa607c061e6612b2ad1d210258a3d91a684b27d2aa4f2818b6abda6954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3522ac3946e3293f9f0d10bef8ccf6eaec4a0c57469fbd738123750da6cf74d5"
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
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end