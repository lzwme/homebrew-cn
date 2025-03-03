class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.8.tar.gz"
  sha256 "0140424474c6b920fb0eaaa11140dc4c43c194a153b3681ad65ae952b2928bc4"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a8b0068faa5672ab65a1c21aec90eb4c45b1676a59acfcdc62405cc17332443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "266656802b450c810e68643abed5c7510a9d5cfceddea13cbfeba8462b85544e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de2d3fc0b1e1459de756522f86a02282cbb4706289771a529fd263f088be5cdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dc740975e40cb8382261421807303e80fa252e5d531032efc8470c0d9191c01"
    sha256 cellar: :any_skip_relocation, ventura:       "d303886921a37cb0d63e35919a7910e008f833c822ccff8eed0c6d8fce967d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82c11a7cffe76914f8831a6346c1ac18b78280d2c75fa24b09660fe726c4ca32"
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