class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.26.8.tar.gz"
  sha256 "9f505a0a87ba0e296ba098d73eb3d81b0f0ab42711c432511c6e95ce864753b0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b01cdaf86fcc8cfa64cc013dfbcb39caafb9c852c3b80ee36971ac906a69efa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "448627fd883e51ce9122015851a8155963968cd88eda3fa0c6cec1aabe509533"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fccaca6fae5876a4ae0bf98630069e7f3bccdb70c07fa48850f5c21564b07176"
    sha256 cellar: :any_skip_relocation, sonoma:        "cadf818e7fce06afa216ce424e0731a4a64728972df08f7f534273e36c3774d0"
    sha256 cellar: :any_skip_relocation, ventura:       "ce347753f1cdcf20915700fbf25eba2a1411c2380f5e6449dba6c8b278c87a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6df66d9504baa279f36114c30118a2c905d5afff8c738613b2c7a447783115ac"
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