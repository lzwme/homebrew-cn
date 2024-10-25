class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.553.tar.gz"
  sha256 "34e2d8aef48d13901f19703f6affb30d72cbb17fe8c4826d0158d69a26053df6"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dbf8db6a82d7059a1e5823b9e166585b69513d3e1f41e048ad301132d9852f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d42b060fb54cb38cc389214ef53041fa10f3d49dd9452fdcff8bfa688f2cf5a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "110f9320f01d8a280b13638a886e1a6fb82c810020d86584a638d1d567e4c88f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4f3aef14e52471843c8a104cd26772041ffe2d516565c3abd60f9616be0e8a4"
    sha256 cellar: :any_skip_relocation, ventura:       "cecbda0ffff0e2ae3af5b9bde219133af92d9d33eb72dd5620f6170907b07c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a367b7286106c6abbbfe98c190ae6b3de5fcdeb8192f785cabe395e01bca0287"
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