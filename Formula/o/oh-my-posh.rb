class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.11.0.tar.gz"
  sha256 "13694a342a2e6e91e3b4f38bf938daf6434620e901d353f8bb0a6e956212ab4a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d9330480944cd9e7db82d22edfcd020448cac12a74f613d7686ef348ba5c211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9556c8371858a9a3a5ae0b451e39adb937a53209aa5cc34c00edbd878009335"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2471ff4dd435280b18eb2dde6ecc9de6eb0229a481579c4e61576e98155219bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "43a264cf5875fd6a44e7cf6fb54b62baa10a31785564697c4329df1c9b4aae00"
    sha256 cellar: :any_skip_relocation, ventura:       "d1659396e4f30bf1a9b19cb7a1ff536641c0d12166c6a5df8a70129e3f9ce97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e00796353330f5b693baa618123289d47066cc5cde97c6283a9638de991b12e"
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