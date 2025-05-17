class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https:github.comthomasschaferscooter"
  url "https:github.comthomasschaferscooterarchiverefstagsv0.5.1.tar.gz"
  sha256 "5d8db3e2abdbd2c59c8d21526ff99b7e6294de49b52eedf4a97b1f118c658092"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b76d84093846f8ea5e35b48c32311fb2ced9ffd60a28eafce35ac9ec2d73ba9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d903f89a748ae990e37241f895b18b15d51bc238095a058b989f802be61fce63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57de2b5e7c062140bcabed75e961a788547a08883303544347ff35aff8306af2"
    sha256 cellar: :any_skip_relocation, sonoma:        "32ff38e557b3b2061cf6f60550cca5db060e86f3233a1fcead0833d04cf3131b"
    sha256 cellar: :any_skip_relocation, ventura:       "f99b26323adcd3a4971abff518c939d93a916fc76d16e70b4f9ff16ce90f40e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e58ac7b2297e1156bdcbd68e6de7e2d308f332dd9238181f85b78860683d3f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d8fba70bd36593d77d54b760f619035cde664d8cd6d2a35c6bb02f79fa29ef0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}scooter -h")
  end
end