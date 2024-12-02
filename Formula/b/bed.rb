class Bed < Formula
  desc "Binary editor written in Go"
  homepage "https:github.comitchynybed"
  url "https:github.comitchynybedarchiverefstagsv0.2.8.tar.gz"
  sha256 "2515fd65c718f7aaa549bf9a98cf514102d2ea5f3b1c0437bbcf8bd26fae4d0a"
  license "MIT"
  head "https:github.comitchynybed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140a9d0772340162a6369e5662a344f6d08366322e4ff1e36fe974f08fc2d666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "140a9d0772340162a6369e5662a344f6d08366322e4ff1e36fe974f08fc2d666"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "140a9d0772340162a6369e5662a344f6d08366322e4ff1e36fe974f08fc2d666"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6ca3ed867cf825422e5b5a133799ecab751b017135bdb2593023977e9a44557"
    sha256 cellar: :any_skip_relocation, ventura:       "f6ca3ed867cf825422e5b5a133799ecab751b017135bdb2593023977e9a44557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f7873e2b5d5e5f871862af9004cdcd4b99fc6b51af6d1e8d100afe4418fe21"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.revision=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdbed"
  end

  test do
    # bed is a TUI application
    assert_match version.to_s, shell_output("#{bin}bed -version")
  end
end