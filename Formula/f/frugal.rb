class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://ghproxy.com/https://github.com/Workiva/frugal/archive/refs/tags/v3.17.1.tar.gz"
  sha256 "51e25387de12145177f74ef5151d27c9546d80c79c68411fdabdabb8dd768eda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4e51c6effc7d2db578f581aba8775b5caeaae46a81f4c9c4549cebe5e3881f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "238991131f3f20dbb9fb9774f252e8595befd18dfcc969e81606cc26437bb9d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92655283f2042d45ae06bfc631fa3831fe3a75fed7e8773ffec79569d97c1427"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc55d22901685631c23a895d07884ed146035d7490ed0fef187f2a3d708d37a0"
    sha256 cellar: :any_skip_relocation, ventura:        "5fd47b52c7e5252cbae1abaa6bd2fea846811e2533d0eab5aa81470901c7110c"
    sha256 cellar: :any_skip_relocation, monterey:       "fb9bcafb87f889fd098770ed8014989b94674d1c0f301c39f7e0b599c6c25878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e6dbcc47e4dba1356d3daddac6989bb1940fcf747ec61562ed6d88f71cdc640"
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