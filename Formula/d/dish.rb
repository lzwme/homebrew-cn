class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https:github.comthevxndish"
  url "https:github.comthevxndisharchiverefstagsv1.10.2.tar.gz"
  sha256 "b325de866ee3da27ca1509b5904caa1dd3ebad5ae96e2e6226f636fb9fbcbad6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "045fdcc6b846a489d563852ced996d3570303a43dd08ee9114ebdc2bf5e1b713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "045fdcc6b846a489d563852ced996d3570303a43dd08ee9114ebdc2bf5e1b713"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "045fdcc6b846a489d563852ced996d3570303a43dd08ee9114ebdc2bf5e1b713"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6466aae55c7c9a7c1b1a984c48bb881a2ff9b9334c01a95f8c56540ac9b4c43"
    sha256 cellar: :any_skip_relocation, ventura:       "e6466aae55c7c9a7c1b1a984c48bb881a2ff9b9334c01a95f8c56540ac9b4c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a90304b3056a31dc3e032deaa3ee008b25a39310f6a0488ffd243d71803b56af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddish"
  end

  test do
    ouput = shell_output("#{bin}dish https:example.com:instance 2>&1")
    assert_match "error fetching sockets from remote source --- got 404 (404 Not Found)", ouput
  end
end