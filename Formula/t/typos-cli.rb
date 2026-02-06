class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.43.2.tar.gz"
  sha256 "0282be800f642af25e10848dbd849fb373358e0c6d8de62ca13dfe913f096a4c"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b32bbe96202772af1e20c8c6d504e6156669a36a4bd78a2fd9ee69d846401781"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51cb5fe5c202db6053292eb4a4c447e49f76fbe63cc0fd2f9aec066555da547e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ebe3d7d2521609c266c72e4d78f672a71ce4afe6e19d7b2116377d4c9712f54"
    sha256 cellar: :any_skip_relocation, sonoma:        "a58b19424ab3cba8297f310ec7bd8cb7105d8511bf9e211040d5a617d6efe4f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d036631c0340072bf8346c923e72c568a4148d994db379cdeacd91d15d36031c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f4f4740967c28cf0976781a2daa342c012701cc143f6b731bdeffe75c9e7c2"
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