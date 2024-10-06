class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.16.0.tar.gz"
  sha256 "7e73d5103ef498969b64859d97e7344442bc4eb4400fcde70d4588101d287d2a"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a26c1502ede31c4de24cec0e7aefcb160cbadb196f504f80982f1080c96e1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3df25f4518281be83310b5b24fe498279004b07b4e77cce2b5c6280d5b2a12c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "405352616429a11a547c987e88d938f234b576bf6ac1c7085ac40ea2c6ed5b8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "525aaae27db10b56eee46f23b02a6069bc7d87352b03d02dd9b0646df36877c6"
    sha256 cellar: :any_skip_relocation, ventura:       "653fc72318d55da217dd8088d339774b0be4e7f0055a4b044eb637a95a10ac4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1464471c9189754707781a8872f16e3673336f381311759dcd2399c05a64f948"
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