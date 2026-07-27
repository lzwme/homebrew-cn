class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.46.tar.gz"
  sha256 "67725d7085b57f8e7ad4cf2094f07a1c173e27d860182bf43f3a934f2290b671"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4c935fdac7b136348d967d8ed64c9ec42905b7f4cfcc503c8111ea3612a05d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ddc43bad0e5eee1d011acbecb78791c28529cb15333c83d003d0ef6338cdbc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c94e13d8e1235260abc316243317b2a00fece4c42518572eac4da206ba0bd1b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "61215373a75406a3e5a515c49a4d60a040eecf0cbd3fba67ce627bba30d4adce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea77b9f0bfaffd40406e835a44b62b825d97b9bc77a749fb274fe54ece816aa7"
    sha256 cellar: :any,                 x86_64_linux:  "83481daaa9b05a3f8de526db3c5f96e5aa0b48929cf541785aa7b8c333449bb3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end