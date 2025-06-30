class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.25.tar.gz"
  sha256 "61a9ca3ea6663fe4fe2c105ca98cb503e8a39edd7b77c8698522aac60ef57785"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67e78425e73a6776e41a38b18bfdef558542562aa36613778a6b23e78bf186be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d68ae46e89ab20e7bf8468241183a73420452af286fcf2784d4ae58cd02517a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b1c246a875f5fd100730c4afd3af70d7d6d3d35973bc057ebd06fd573d99296"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d0ef5c77fa937f63dffc0d5ff2edc62b81ada5c64d57e3d625666dab97d7bc4"
    sha256 cellar: :any_skip_relocation, ventura:       "fd2ac9666610fb2e8961b184a3d9e948791cc2e8eff2203249c090ff2c2c4c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2611272577c5d20fb87875ed7d9b0c15c9be6b78940529780de95e3889d5c307"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end