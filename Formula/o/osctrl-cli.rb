class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https:osctrl.net"
  url "https:github.comjmpsecosctrlarchiverefstagsv0.3.7.tar.gz"
  sha256 "39649f2db1b523293df2874dbfcb65840d3091c8341cc415d50ef53797cf994f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfc288f90bd7bc332b3eb814e315267bf7734793f96b5fa2469c8a13a15e2271"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab46a244d3040056210c4f3a8cb38ce7af0eac6e10a50bc77283a01e642c1e4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef90c57682735d45f2d770fe9081bb35a9fd35253787c5070fbb0785263223b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e52648f1fe2e66bf3a95ac1e5bd7a33c71860002088b6c46a1721d9ac943eca"
    sha256 cellar: :any_skip_relocation, ventura:        "4a9d2fbcf08b3fa1c2926f82704004c06fb5e7d39f66695bd30f91fe193f36d2"
    sha256 cellar: :any_skip_relocation, monterey:       "729211505b74bd7b8292541a859538940de10cead814c32ba22a28edd459bd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67c512a0dc81d04437f94ccdcebb57a54ab672185f8dab494c68710544fb70e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}osctrl-cli --version")

    output = shell_output("#{bin}osctrl-cli check-db 2>&1", 1)
    assert_match "failed to initialize database", output
  end
end