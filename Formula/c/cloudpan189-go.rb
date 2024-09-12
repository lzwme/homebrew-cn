class Cloudpan189Go < Formula
  desc "Command-line client tool for Cloud189 web disk"
  homepage "https:github.comtickstepcloudpan189-go"
  url "https:github.comtickstepcloudpan189-goarchiverefstagsv0.1.3.tar.gz"
  sha256 "a215b75369af535aed214c94b66ebb3239b6ef5fcbc2f74039cf9c3eda4b04c1"
  license "Apache-2.0"
  head "https:github.comtickstepcloudpan189-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "793542588a08328d55060fc0faeb3808bde9656eee00e8df0b9ca98ad70ed9b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c66a3ce0426a356d4b5c05fe95fc6213ed4c867048157ebbc862ca9196af857e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6870cbe4123a3eae721cc676130d2146794d9a3631268d48c579430a923173f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6870cbe4123a3eae721cc676130d2146794d9a3631268d48c579430a923173f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6870cbe4123a3eae721cc676130d2146794d9a3631268d48c579430a923173f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0259637185f73febd2da780378accfa232b124b8cb46aa376a64ce5adc319140"
    sha256 cellar: :any_skip_relocation, ventura:        "6ab13514be4a47d60c22436daad9bd2ca0612b61eff549630d8548cb24405424"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab13514be4a47d60c22436daad9bd2ca0612b61eff549630d8548cb24405424"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ab13514be4a47d60c22436daad9bd2ca0612b61eff549630d8548cb24405424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c193bc56690eef410bdbbce6d6b774fcf658f16b114ea0222afee18591d361"
  end

  # use "go" again when https:github.comtickstepcloudpan189-goissues101 is resolved and released
  depends_on "go@1.22" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"cloudpan189-go", "run", "touch", "output.txt"
    assert_predicate testpath"output.txt", :exist?
  end
end