class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https:github.comxeol-ioxeol"
  url "https:github.comxeol-ioxeolarchiverefstagsv0.9.12.tar.gz"
  sha256 "f253c0ffff46968319c2fd05ec2dc08a81de6684c63aa946278b199e97ee4d01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71192233e7b53e4671b10b3f55d5d8e9a8cd9ff9acfe787dad7be2f1d7e2fb6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caea692cdc31500995c93bdca081e9d7497d7871aa6ded4568c294d30fdeeb7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6bc7fcd06f0a960ed64bd839f4cc5fc295b554aaa46dddd8d6a45dc9a3484dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c1638997e46442c88f1077c16532b0c1684f9485b428aa4090adc43de4b8c51"
    sha256 cellar: :any_skip_relocation, ventura:        "33e5bf3c0a6b2e8556670cf6793b04bc8aed4c83a5ee4f1930f03ff2ba1dd82e"
    sha256 cellar: :any_skip_relocation, monterey:       "d7e5f74311330ef74c4ab244ff28382061e650ba7cab251c2b9931c9155cdda9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf158f85da256bccfafb2c124d635b8002fa816f29c98c3822d1720b61c5b3ab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdxeol"

    generate_completions_from_executable(bin"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}xeol version")

    output = shell_output("#{bin}xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end