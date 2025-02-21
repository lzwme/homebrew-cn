class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https:cot.rs"
  url "https:github.comcot-rscotarchiverefstagsv0.1.0.tar.gz"
  sha256 "5021dcf1c754865081b4bfa1458cc4adeba96da57f22415cefdc8d573324788a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b599a99508f3448374ad19a429fdd8ef2b0f5dc10d36db8ec6af734b3de5f187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b0b50bcb17749b9bece0f3b6f819928de35e32ba84e19572cbbf2c4aafe05d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "493b0acd6cfbf37ebde141c5a162993d469ace9b18f427b512b7cbc5f16f50a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd6b2284d540d6af24d8475b2a12fe004c2d06fb89e974cabf4208121b3cb5f0"
    sha256 cellar: :any_skip_relocation, ventura:       "9380a61b2dcabd07b567acde371b314ebbbf10547ab1dcf83d686000d10cfa65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f86f3160a5d700a4472729c65d52326422f69cd7d152c84e97d8a81e2d7a0758"
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