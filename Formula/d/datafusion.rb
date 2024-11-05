class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https:arrow.apache.orgdatafusion"
  url "https:github.comapachearrow-datafusionarchiverefstags42.2.0.tar.gz"
  sha256 "028f9d5b00a8d751cce6de30cf164fd27382d1f663c6238ea3bbc1e018c41cbd"
  license "Apache-2.0"
  head "https:github.comapachearrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b39dacca75f79c0b2df6ed7a24084e241717ce79336d94435c0f0ec1008ec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36bdf97583c2c970c1b062c0cf9975270e72703d6e43b5a11bdd9097fc2188c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e7544864aeeefa424706dc1284fb54ca7252139db420c83975a3a96d6a59a5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "739b27738110478113cb6630ade647f97ea3253607794b390f2cff482ec6b90a"
    sha256 cellar: :any_skip_relocation, ventura:       "354a873218d05df55e9c531a1aa669a2d8f263900823466672e0e377f075184a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05e1482864c33b007f5c3e842c642c481805999209987318718278ef27fb0c23"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end