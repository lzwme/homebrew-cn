class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.1.0.tar.gz"
  sha256 "b8d9314db9bc418e24fef1ee449b38c588801fb5ce489bcc57e80f2c858a06d7"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d20a83bc91e4a336440e4e9b392fe5d24acc80dfc6b168b5f71efdfb23497fff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f0d594c38405e9477ce876bce1de8ec6d58a115817297e59593c3b9a45e91ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "510b20f7ad3e7a5f7093c5f94f493efc3aca882bbf7785f2091d381f4788e5f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e333a63f65878d722bce42a73ebfb087c7ae8a735f3135e390dba927a512d517"
    sha256 cellar: :any_skip_relocation, ventura:        "f671ccce2bd6d443f1e77c756ba7a9bedb65d253982b951595b14a2c02c05f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "c64098588ba9cdc0ba4cb35822ac91b6e127641be6ade62ab44f488740f96df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a5e5b04e7e5aed68ce4517bb2159cbaba1e912140b48860e8d29c7a8fda482"
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