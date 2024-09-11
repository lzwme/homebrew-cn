class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.542.tar.gz"
  sha256 "1553c42c51069ce4d7e1ea23cc53e70abdeb56e24a85198d1c1aefec5f8032ba"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1ec08e6beba8927d6e502ae2d371405e1e4949229d93f50ddd94026c863fce2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "543af7b2197413da8348cdd759ba0e7820cf36c9a38e0290ca39b0ea0e24f765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f383976b1d559b0c7150ec072697ee324a9a2df7202def1dd1426aad8dbbd56"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d2c58df487a97cf59b24cdf83e780c282298e3ffbe6d4ad6f322a37a7a0e3f9"
    sha256 cellar: :any_skip_relocation, ventura:        "b9f77d24162cfbef9d26c5f532628b1d13a2bcf82e2bc6c38f7752d7af1c77b4"
    sha256 cellar: :any_skip_relocation, monterey:       "d0ab9c3b4f29b3a8130f1b02cbf3f86f662d185afd3690275bb77d191232c3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "477b536ecffcbae093bff6077840ebaca1b5ad7c823ef90f0b1ea6fae2c6eb46"
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