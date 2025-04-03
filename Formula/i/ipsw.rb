class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.590.tar.gz"
  sha256 "a9e456ea25fe76a765d18a84a55e5d69c44972b4ab69bd0a1babd2be4e7bb01f"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc67ad2797ea968394e8f9bef36d40d5217a20767bbd0838fe985043c4d510e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3271395aaa188bb5792dbc9d63346f40cda81597cabae3e1b718966b0f9854bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd17432ad7eecd85cd17ba1a27205ac49afe3f9837721181c4f8dc8cbf5e4f0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba6629a25c974bb1317f7dea49556c0102e2836889cf9925872f774688524f3"
    sha256 cellar: :any_skip_relocation, ventura:       "d555258117e69573bd7c8be6148e9581a676abeed60f1eed9bfe03c7be3aa3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a385eff0b05b20208e5183688d0f74b30020dd2a90e8394c026178fda1cc722"
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