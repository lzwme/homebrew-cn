class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.20.7.tar.gz"
  sha256 "bbcd8114c89594af49b95be76d26745f640c70b909d80fbe2b85147e5a6fb5ba"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d54a50f19f6edf4c123e0db4794ceba94b7544c041c832887b1e58f6c465818b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90d85c2219a925bfb2ff712f8b936bd555ee676761b52c8a2bef141d9300978e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56dda4f3dd99383ddf46cac8b2654346ba2abaaf0a3f19b05ff591d495681f7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "02415f623bc8a5ab58178f8002c07f27eda25e8e8884f832d86f72c1872129ca"
    sha256 cellar: :any_skip_relocation, ventura:        "785e6ffd47ddb125b8abe9b094d9b4f690bc61e29391989c00b1c95df67aa484"
    sha256 cellar: :any_skip_relocation, monterey:       "28d86af17ff12eb0d5c52d26a222d1cd07148013b3a2d16c1649d82b0eece01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8ebd161fd2dd5ba13699338a3d49c82d33c8941cce97cfbbd155d627fdbc08f"
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