class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https:thoughtworks.github.iotalisman"
  url "https:github.comthoughtworkstalismanarchiverefstagsv1.33.1.tar.gz"
  sha256 "97a5c244a6ba2d91e3b1712de380572371323bdcb2087a702f961a0ff2eb0b5b"
  license "MIT"
  version_scheme 1
  head "https:github.comthoughtworkstalisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bebb205984b4e6afb18f7aaa0891ba9082756c488a3b0b9c976834e86fd3387a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bebb205984b4e6afb18f7aaa0891ba9082756c488a3b0b9c976834e86fd3387a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bebb205984b4e6afb18f7aaa0891ba9082756c488a3b0b9c976834e86fd3387a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee1ef464ee611111a2d611bded029f1fe7540da4558286e3068182e692a64dd4"
    sha256 cellar: :any_skip_relocation, ventura:       "ee1ef464ee611111a2d611bded029f1fe7540da4558286e3068182e692a64dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "995f49826e2e2ba4acbec116d4572b0ab40d91909d8511a56c30b2b5d5cc3c4e"
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