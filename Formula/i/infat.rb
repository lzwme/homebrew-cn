class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on MacOS"
  homepage "https:github.comphilocalystinfat"
  url "https:github.comphilocalystinfatarchiverefstagsv2.3.3.tar.gz"
  sha256 "d07e1331d8afc54302c09e35c392255be8484d4fc1c30a953190e892115253a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f699e34947ef6255614d5ef43ad57750e023da0df9a78cee225e21d6550c4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13f0d101acfc9a1f39ccc323f3b9cf1565fd1e86166467066189d31dbba8c005"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81973d25b586288015ef7f7c5e0900939dec2507109d71ead89e77765cd36609"
    sha256 cellar: :any_skip_relocation, sonoma:        "c22114954d58710a37a7d9786ce99a3cbf807b53dd8ec78ef330770f4e0d2f26"
    sha256 cellar: :any_skip_relocation, ventura:       "4465edf89ddbe68a0a267dac3577a9ac40b37f1e8e5318a21dea1a2f0153839c"
  end

  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".buildreleaseinfat"
  end

  test do
    output = shell_output("#{bin}infat set TextEdit --ext txt")
    assert_match "Successfully bound TextEdit to txt", output
  end
end