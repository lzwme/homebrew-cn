class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https:thoughtworks.github.iotalisman"
  url "https:github.comthoughtworkstalismanarchiverefstagsv1.32.1.tar.gz"
  sha256 "4ae78209783386a620749c51f0600cab1cfc67636ae7dc5a6462941c1c825aad"
  license "MIT"
  version_scheme 1
  head "https:github.comthoughtworkstalisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abccf9ab0d5ad42bcf4b8bda8ea08b1d379066d87ac26f144b01bef982882834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abccf9ab0d5ad42bcf4b8bda8ea08b1d379066d87ac26f144b01bef982882834"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abccf9ab0d5ad42bcf4b8bda8ea08b1d379066d87ac26f144b01bef982882834"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab7c8f6ce164e10159211f1e88ecbc1105598b565dd7efe1b549a81fb14bb41"
    sha256 cellar: :any_skip_relocation, ventura:       "7ab7c8f6ce164e10159211f1e88ecbc1105598b565dd7efe1b549a81fb14bb41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4aa17cbc11f8061a63fc224a10868c47ed20f72140639c67c409d2b10688cff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), ".cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin"talisman --scan")
  end
end