class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https:cot.rs"
  url "https:github.comcot-rscotarchiverefstagscot-v0.1.4.tar.gz"
  sha256 "cf2dade71a6fcb4bfdc03c1db423b45eb325a9a048c933afd506f49d55fe6831"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1583c490b6f0988137ce032a0487633f090f9c9e2b4ed95b392e0b1f84478886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dc27fe705b3440cafb09c61556ac5c83dc0825bf1c82e36dbd76fafe1842d94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44f9a45e468f918b34e7f6e5208b932156f15f5d264839988880352b4fac855a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bde6597ac6cc5c57ac0bf7dd27bef8c6af387e2fada8caa364c4b3bc6c966ea3"
    sha256 cellar: :any_skip_relocation, ventura:       "34cb44ff4f6d074dd97504f7b983535398f42d6e50e539dcf896d7f54e3e5492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7de8aff79ca421554cc9c09681da0ef559dd404abf0aa8326721324241d73d0b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cot-cli")
  end

  test do
    assert_match "cot-cli #{version}", shell_output("#{bin}cot --version")

    system bin"cot", "new", "test-project"
    assert_path_exists testpath"test-projectCargo.toml"
  end
end