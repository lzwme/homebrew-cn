class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.30.1.tar.gz"
  sha256 "89db1c914770233ade830f680f3a0ff7909454d4f72a60394ced93270e86fb2a"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e3248dea52a85f684dfe3b892a5d12351683f721a63a4b63bfa84d61ea84e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88e49bac126083d57a65faa057c26b303b1e4d291344f2950b2603831792bb32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32931d795403a2da874a8a8f8d6a8c28a748cdad90c0187af1e7ca8616dd51d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fbf95c3c437fb27f9ecf259234a509b7c38374a4844acbbd17a290b759b4ede"
    sha256 cellar: :any_skip_relocation, ventura:       "73ed20b3166a2b1097f7bd64e9cd3afeca7f8a21875611ee48e140ce0f99f949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436d8764b4893d48db8307563a8d3ec18bb5b6c344e6c9334d7c10db4636c602"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end