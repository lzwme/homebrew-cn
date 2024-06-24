class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https:lune-org.github.iodocs"
  url "https:github.comlune-orglunearchiverefstagsv0.8.6.tar.gz"
  sha256 "4c89eb9ce3469e5de9f74df325febf9fb25a125dc83c40ca3556002290211b70"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8057629010067874c0537f70a2d68455f24503ce1367bcaf9abcfa76a6b469a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629d20d4022a30c4b391da157b78addf4e88f919a74c0c102b45fc560be70221"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1b0507d13b641bdbcc3e946a823590b5cd11225c9afd3dd042920976d5c0aee"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9795912699275d8dc8a4f58d275e3ff5f9eb5c5e073ca09888fd1c217f27d36"
    sha256 cellar: :any_skip_relocation, ventura:        "60363fc359fa79faedeff5b63f9f96f487ca45d3c110175061fe92e1d46949c6"
    sha256 cellar: :any_skip_relocation, monterey:       "184432e756778c1e696b157cc17224307396cd07691a7e043d5555b767b2493b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270ae065c6fd445d55c6d288de0547ac76824629f7e49f575e3c04587300aebe"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crateslune")
  end

  test do
    (testpath"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}lune run test.lua").chomp
  end
end