class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.20.3.tar.gz"
  sha256 "143c0f8bc8a5a342fde91da8990b3aada12ace26494877c0ad104efd13909668"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "488f169596942cbd4f203e1ad74ae9ecee3f4da44f892f8ceb4fc885e3dedeb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2baf89214ce2296fd5a0d68175c40fda71559bf1fa2288d66514951cc88dd1aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5614d7ed84fd38195302cefd2ab76cb7c6e041aa3bfbbc625ec02c64d3f1a6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f78b7acc19ba8609ee1e77b9e40efb4b5edef34043db3d88300e5fb6a875d478"
    sha256 cellar: :any_skip_relocation, ventura:        "7a367f20f4e881e64151ce8547f489b187cc12d9fa7fa99c55b22493a9894ea0"
    sha256 cellar: :any_skip_relocation, monterey:       "7dff94e7da406208c58e00ded8b61e9c2ac3e131a52c84d0415163281ef76d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab8c27561d972aa4499f6e2b3f03801c727ea98a7a24679e108da4f9178bca7"
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