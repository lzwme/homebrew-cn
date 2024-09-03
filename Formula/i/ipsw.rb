class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.539.tar.gz"
  sha256 "d89d98b771bca0cbabcf123f16ac039c7a9a92c0dd077f203f6262869fd5bb06"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b4289b9840a57035342b4b8bf9974507ed7a8ed5d8d02061794b018ce05fa74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c01c75bf79cecd37f8895988a1056080c2c28b7be977e5afe950f828daa354d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6450b9c1d1b0651a2ccd7e7098bf105e04fec225ed717a494b66f060a6e10e44"
    sha256 cellar: :any_skip_relocation, sonoma:         "21202400967f69598806fe71d71318ffacaa08f20c71f1f7b75a4d12406a58b0"
    sha256 cellar: :any_skip_relocation, ventura:        "04764ab23fbc9558ed0687f4bc8df9a3ef14584ea3d8173417b7b76d562c1f07"
    sha256 cellar: :any_skip_relocation, monterey:       "4cf5fcfbc3d3449d64a2525c97b419091023c31b294eaf56ab98072b2cade637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b7a5b13bda5bdecc3b14871f9623e18e374f6596deb37f72a4ee90a99e3d63"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end