class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://ghproxy.com/https://github.com/mandiant/GoReSym/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "2ff64e97576f4109247f3204b9e143fdea53fa5d7495cd0e6b9eeefbd0b13ff9"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bcdf8a5dbf63326b6c752caf83c250b70d9a5227fa3a2318139f9c3ab54db9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bcdf8a5dbf63326b6c752caf83c250b70d9a5227fa3a2318139f9c3ab54db9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bcdf8a5dbf63326b6c752caf83c250b70d9a5227fa3a2318139f9c3ab54db9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f423a5522aab1d1797c86d05e52f4911bf06075b70fb121bbfba61a4c543167b"
    sha256 cellar: :any_skip_relocation, ventura:        "f423a5522aab1d1797c86d05e52f4911bf06075b70fb121bbfba61a4c543167b"
    sha256 cellar: :any_skip_relocation, monterey:       "f423a5522aab1d1797c86d05e52f4911bf06075b70fb121bbfba61a4c543167b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29e6a262cefb1bb595ce64d17728a92f20ea06df82833b3e11970b08670017b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/goresym '#{bin}/goresym'"))
    assert_equal json_output["BuildInfo"]["Main"]["Path"], "github.com/mandiant/GoReSym"
  end
end