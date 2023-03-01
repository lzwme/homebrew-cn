class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghproxy.com/https://github.com/apache/arrow-datafusion/archive/refs/tags/19.0.0.tar.gz"
  sha256 "ecffd64aa2a3ae9db62699d2521f9df93c1fe1007001f253f19c7447efff8e6d"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d80ca56f89f2dc6b279705cf84f99ef94c9f6f587fff0b2c21b08f0d9cee483f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41b965c7cd8142598614ae1d14443b24e01e9192449bd53db04a132e734d361d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aef2ce1d1c00a73f2047923ed6ccb78da23916007b78af5b6714aeb46bc0fd37"
    sha256 cellar: :any_skip_relocation, ventura:        "e577c4b3db71bc5aad5573a73d2c40e2e4ef81bdbaaf00af9da4dbe257a3c2c6"
    sha256 cellar: :any_skip_relocation, monterey:       "10155987c2c4cac6e07a50954529d6f1df829f84a6a54a386374ddf20c3c82c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "309cbec331f1d570cb35e0027df479d4d4c7b51c09254476923ca948e5dc0a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0fbe997195922dd82c9bf799f9253d3a2f54b7b6e5c023559e08bc39414eb60"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end