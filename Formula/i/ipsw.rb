class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.573.tar.gz"
  sha256 "3bb6d9171e0bc5d7934cffd28829ea17cfe9262b816eddb0d4360f2d7386a318"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac9acea17f34687057100da9c2a231f47541c7af872b8bacc5647296f3da19c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57fb6868b9cabb88b3afb58c800c9cad3c3453946fb67e9101bb716df3c96006"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b0474fe2b095be875ef4deb0757d2b42ded713a39b494d961b25b8b5bef78ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ccd5d0bdf0695b9d293da584a85af27e47d572b5dd407abc31ef1bf2152d770"
    sha256 cellar: :any_skip_relocation, ventura:       "d33ebb266ead852f7c48eda530c30d9b448b8621b61c22f40fd7340a1237f49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87d58bce50d5dbf24a6219473a49df5c41e821a442d59309c23102e5ae32654a"
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