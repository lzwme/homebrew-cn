class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.564.tar.gz"
  sha256 "6093f9120130d57144cb9f5b42d4ed8722dd543cc2ba6ffc0dc08b4671c5851a"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927d034b0b3f5460b897993fc7e7359315ee8d055f89a1a45062f56c1ba0990d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaa381d2671a9a2887edba48833095c151e0f3227cf4143fa6a696d381dc79be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec11e00c4e0d68f85a90ae7b885571b94baeb51537ea813c8ede9c37406a842f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6de898c692b1204cc4824106c8e37cbb6968ff7a7ff417b9da3f2dfd07999e7e"
    sha256 cellar: :any_skip_relocation, ventura:       "9d7b1a8d7cc3b3af813d6908b3d9fda1307179486e11db178fb795e5fdd41ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4166a5496e9db054738eff0b1d25f6d0e8f46e604f7be88d69639c78890a51e1"
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