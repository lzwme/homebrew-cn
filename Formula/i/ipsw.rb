class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.608.tar.gz"
  sha256 "adbb4251ff7140e780fb7db37030e31c03c4d0307f19f1a8576fd8772e1e35ca"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "746d70b7f7e75506a21545ca154a9983d9f80f57f0bd3b2c1aa72a9ba28f95ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8066ea25f1e03e69ddb1376fe2abf58cd4b1e790435155447ac6d32156ed5031"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a191732737409f5bc6b32ac2893a8c893d094c10e77517ef15579590e06bcec0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b03ba2a04a7c08ed39a8694c0762055a13f690af130d50d3f2fef6dfa45c019"
    sha256 cellar: :any_skip_relocation, ventura:       "4090f6559ee62d75f46b7c48e22ffcca1fc6c8f1f398cfd0de7069a68009252c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f6e1cd371c746dd80c2dac6e3ec2f735972ece6c62b757da0ad6924c9951118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "915696572039b1a5fa6062e274a53dfb606e0c2368d7f87dfcd38fe3249e6c45"
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