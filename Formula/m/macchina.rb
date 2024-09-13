class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https:github.comMacchina-CLImacchina"
  url "https:github.comMacchina-CLImacchinaarchiverefstagsv6.2.0.tar.gz"
  sha256 "16ab0690f9a998c7403e26439626ce9f70cd114898a40ecccd28c47ce25d3f78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d062deecf6c7a7796d970d66ccbe85587a1858486aadf4eba5b162787f42274"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47d4a742e2b74d3c45097c723560acb8e6b3dbc7b6b5d1d7b7c920936cbf7e58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e86cd5dd31c901b20b29c887ffc24a979d9cdbf82444d64ecd96ab80b43d1f4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "74227af29e52a4dbff49acad3afc762c0be6fca7ec5b0a4ca90e892f8793cdfd"
    sha256 cellar: :any_skip_relocation, ventura:        "dca0803702279d6aa00059ca062d6c7bc0f96208a076319a878ac1de963a1f57"
    sha256 cellar: :any_skip_relocation, monterey:       "f03727d52e4dd67dd11d256e02cc89617baee9ad4c1ceb020187c4efcb554672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a7be660b526305bed459befc38515c6dcf82d22a65d093a53ea6957730124d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "We've collected a total of 20 readouts", shell_output("#{bin}macchina --doctor")
  end
end