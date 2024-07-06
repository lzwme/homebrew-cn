class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.23.1.tar.gz"
  sha256 "44074cb064134f3065b761367a1800071efa8ab52a7d744111c920a34d5cd2c3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "915076918fbe96bf15a5fc4dee19a916e231b375b4f8ab18ba8feb4238516751"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76a7ffd0634c44cb73b296077cbcf12e5730edfd71f4ea754cbce2f90c0e2447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89766f3e3cf241b6fc32a5411ae9b18ecb6759fef9fee2e245327ad197745ef4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c981047412c3d8b1414bd79c0311ff75188a8ed81183453d1c3c31040414ff7a"
    sha256 cellar: :any_skip_relocation, ventura:        "b748dfabdd86dc5adb38f61b4cce01f6404d672b02eca62089582fb7df570e4f"
    sha256 cellar: :any_skip_relocation, monterey:       "0e3acd5bc350ac4bf19420832ebbeb50e22519c0dee49c06708dd929c951df6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f184d45bf5ac2a11ef3f48df9d16d965c2830826f3519ca4a2d6d749ef27c70"
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