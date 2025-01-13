class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.563.tar.gz"
  sha256 "4ab3f646f7c771ee940d31fef73ab7463de586d4b450e0bcc00e248d7af5dd07"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51636178964486c4d3a350caef4abc70c4666b47a7368c103b2ecea812a58532"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba432c4e98d9e34aa0ab46ec3d09ecd4197bf10b54e7b66759d8536727838b9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bc919e709ac60d3a26ce130a5e703d51c2cddf53b6574c1a99a79349d358761"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2ca1c126ff17c3840ec2aa53b1d9cfddad16223ccf046071a8beeab85f950a4"
    sha256 cellar: :any_skip_relocation, ventura:       "f0d02e34c00e53f6200eb25c82f7f809418426557b710ee92ddbed01f2126322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1b8537dd6bd4c6de875e6b9e20acc4deea76c14c2e7960727f03f9eaa04f787"
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