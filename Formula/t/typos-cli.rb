class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.22.8.tar.gz"
  sha256 "288b1d113252d58727642f89772bf29dc95ce79a7ad04d0e29e119a6df0e2170"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4de25bac0ecdbc21047519e98f216b18f629f2071730343d51ab574fa7ff1a24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0465d661ac30306aa47646a6b09229cd623bfdff9a95bd64165bf9fb7c93c397"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8089c82766c86cd3746ca190dbdc0e89f404e0f349dd568b61bf9ebb69de2b2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c902e882f6719bd0cffcc79c0ad215b058f2b9457f1869c2caa364cb1265c9b2"
    sha256 cellar: :any_skip_relocation, ventura:        "68b9c9b31794fc17e6cac419507687d8afc7af3c18509e7f301e74a4edf5bf86"
    sha256 cellar: :any_skip_relocation, monterey:       "1fc5ae915eeb52aa4a6873aa4c63d9c6d3c17ca0900caa37281a1d6eebb44b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc45d89778f259f7012bafcda8cf3117f9d88f9365bb94622478455add1b5555"
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