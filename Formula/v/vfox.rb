class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.3.0.tar.gz"
  sha256 "1d60b0538a6cf7d9bf5d99a7bb6159e449e13249328c229a927f6bfa4322d525"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0a401ea4e4d49da416f332def69438402e24a2cf7c350b2fda8b6f9e7581b3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "127c9e239cceda2535400831ebcefa576a48375b802e74535723a58c4ccaa2f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9f5d4698c3ae9fd5c3c420cdeabf9a5470f90b4956f997a34f94f25427d5d82"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cf1f314894cd6e2fee1bf986c688c59dd84ba717ed800576ab7aea8eff5f6bf"
    sha256 cellar: :any_skip_relocation, ventura:        "7d6d9c9f214e208b1fec632e0209dbe6faff3e186e4706615b8cd2df68933d76"
    sha256 cellar: :any_skip_relocation, monterey:       "0ff55db9ea3291f84d3e0ac337ef4be259d4ba754e9352b64f8d4614bf500126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a47357346626b14c2a9f303950f9358059a077c432d789db5c1d34dba9bef3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vfox --version")

    system bin"vfox", "add", "golang"
    output = shell_output(bin"vfox info golang")
    assert_match "Golang plugin, https:go.devdl", output
  end
end