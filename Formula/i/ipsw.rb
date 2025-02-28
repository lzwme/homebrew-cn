class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.578.tar.gz"
  sha256 "a5703c012172d4790978a0ef96130294950179c22470f16434087eefd1187675"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30cec62d812f339602628bae66618378253b3e4f95c9387fccef1c47b946f337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab1d432bac83c97b560b40b8cd981df8ce454642ed474f9442fb6bdda2b8f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc5508edd384114fe7a37c39aa608a610fc38c14354bcc28f5bffc4082b7b739"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bed9bfa0ce043a2a4583362aef9ba474d4657d189a429eba95c54f4a6ad5686"
    sha256 cellar: :any_skip_relocation, ventura:       "3667040cad9fb6cdd81909bc52109b082f4f1c761b1cefc9b2a82457783fa240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70768bdd986363a98d7cf8f3403a4eb60b633eae290eaede7bc22d65334f87ec"
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