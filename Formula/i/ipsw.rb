class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.603.tar.gz"
  sha256 "7edcc34e1182624ff34ea3bb534dd5b3d2141805a23cf1a9e0b9bcb9d02644a0"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "638043508131bdff4e50cf64b026740287c6540402d1dd4026d4be5d4217920e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91cebc30440a26e1778e0c3a526c0812fb365a80ed96fec45fcd3bc742cdfa09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac0fc9e3a0308c906233994f4ed3d477c4c088a492e1df3433fc392f568d7043"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1cb741b139c07ef907ec3dafa9d58a5afd0b0ce724b188856724f654d2becf6"
    sha256 cellar: :any_skip_relocation, ventura:       "7372c6f00dd779f70d51dd3a92ec3a329e84bdd98d3c65b9ceffa63feb5bc390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04fcc9a17c03a1d81b68ddcc60a62e46a764921adefbe7674b8566b1bb533607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d45edc7f8e5b7a277764ecd0110abf99939ff0cd72f0c2427df6feef0b64b6"
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