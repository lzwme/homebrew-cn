class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https:thoughtworks.github.iotalisman"
  url "https:github.comthoughtworkstalismanarchiverefstagsv1.33.0.tar.gz"
  sha256 "2a31dcd297c82d1b0ffa9303c34d5ed9d2a5e14a33236d26ab17b1db1f9f4631"
  license "MIT"
  version_scheme 1
  head "https:github.comthoughtworkstalisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "546b00903de07eb94c719ce11d4a5e14120e49d3a2dd1c99adbc30578b03d63c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "546b00903de07eb94c719ce11d4a5e14120e49d3a2dd1c99adbc30578b03d63c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "546b00903de07eb94c719ce11d4a5e14120e49d3a2dd1c99adbc30578b03d63c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee085dac06950cc3c8baca47d15c176e1200968317d7499a7b2d39278f3dba9d"
    sha256 cellar: :any_skip_relocation, ventura:       "ee085dac06950cc3c8baca47d15c176e1200968317d7499a7b2d39278f3dba9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "227d60f256228145098aa849fceec1c44cd3427f4a0b5d54ce0f94de8a2d4b1b"
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