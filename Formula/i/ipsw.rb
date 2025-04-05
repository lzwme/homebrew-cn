class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.591.tar.gz"
  sha256 "79f5a72b9a79e612b281738ed585e913a81d2cec72ce89fc19ed2a63fc434bb7"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebbfdbfb95ea54e9a703561435822493e8fea6c2121cfe4e8e8d24e579678184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89408e623a2e866492a803c368340607d9891fc3cccf0fc5578a98005d0f3a92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "002e545311ae8d7ff1aff101cc9b368431f38ca99e9d841cafb9c78c63f81b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e4f7757a9f937f61299693a2f496aed116f79615d429d45a72028d74a06812a"
    sha256 cellar: :any_skip_relocation, ventura:       "05d7d56d43f227fd4672f5e9c348d7f9808d16af891acef9f67947e3525655e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bcd61d7215ac12e126ab4f4e9b0a93c4cd18fd45c243e451470488408c5ecde"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end