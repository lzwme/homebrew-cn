class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "cc111101ffd48a68a15f6ee871391a5869844f6a3e007fd7faa017cc30089264"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "882fd352fe5913455e9f171f1cfd2a938808ea4c8057933a6e981505f1c5020c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b71348270f6389bc080855d169ba9eeb0a1ded61f8066c630adab75802caf02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ae717dfb6f052b3ba6e4ac4807c9634b95a68117bd787422d21825de1dcc47"
    sha256 cellar: :any_skip_relocation, sonoma:        "e866e4bad09ffc37a5708309124d9a8b5e8832a75d2fad7fd9ededb9b7e65cf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51999c91bed1cb302d0423db6050f68f79715074539bf4f74b12a3389a8c3e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf5b21cf2ae18136de9b498cc2314baf474ba7aa27acfdd0a1545d5d933d437a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end