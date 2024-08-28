class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.8.0.tar.gz"
  sha256 "ddcdbdbbf65c51fda36fe1f24a19658f53915769b7df0ea483909eecfa1e3562"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ec60ce917eab0084fe62da89b26e180b092cc5b6a8114e2542fc3d6b8989652"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2e3b8365d8512e4be37606ccb68085390359969307892b429e6d725859a5790"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a45f002edfd3bc8c70d97e4378d4f6737bbf9e6bae21a030fb1a602e01f8118"
    sha256 cellar: :any_skip_relocation, sonoma:         "21f4d84b7cf08ba820f0f443f44df720d4893196c680e12a0b03c9205353f305"
    sha256 cellar: :any_skip_relocation, ventura:        "5b4588ef6d516834ccfdd74885c79284660853521165a6940e395e4967327bb3"
    sha256 cellar: :any_skip_relocation, monterey:       "282833b675d8d1e943040a76a50d1a333399c53ec0fc3394d9a4a0d66abc785c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e425e6a572dc777fe4d9544ae9252f9415ac8ce653f5f589d6fe94de97c84590"
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
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end