class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://ghproxy.com/https://github.com/Workiva/frugal/archive/v3.16.20.tar.gz"
  sha256 "dd1795373492b03d53a48d89526dd8ba11eac3a97bab2f6de920ecd5e5bcfeb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "408271300d3e8d47c0ca78dc4022ebe91c4400eb95b5083b74190560c130be3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f425930954c08c8af901c2f3c02d60b46521a08a12c82e99d60444b0af8a6c29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10b3e58d31960fd824e9b7e6a464abf0b9099ca7e3acb68294c18bf8e178e202"
    sha256 cellar: :any_skip_relocation, ventura:        "4d7e484d9831c74514e3551865c219192a1de57b149b0c018051b5582b9df18a"
    sha256 cellar: :any_skip_relocation, monterey:       "ba025fde813c53492e5b2a859f43c67898329788851418269464b3e8b7e35fad"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d501fba1ac6cb0c35f36e7a7ef9e9ea8b313ecd902746b0c4d967cdb364fcae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa65d189a7d9800910cfc0be0cdf383d890892e451062a369c80a8d736ae631"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end