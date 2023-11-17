class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghproxy.com/https://github.com/apache/arrow-datafusion/archive/refs/tags/33.0.0.tar.gz"
  sha256 "4a698e64a0ddc1c1ffea3745c25daf24ceed0bc31375aea1074fa9d6872f9db4"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f356f56ea90d72e824082d27c31a8df61f0d92c8803427d00b59b5e2f06ef726"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca9106e247a5070c94587de21e14c0faa5a631aa123c48397c8916e944030fd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c721d0abf9e46069812ba84d7f487d190bda6ffa0be75354361996e7f348f0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ada1265aa7e054dfb2eb9fd66e0dcd4752b081a8851bf821c493ea67ade3270b"
    sha256 cellar: :any_skip_relocation, ventura:        "3d5ecbea76aacf35a0efd275b9b9b55099917fa3659aea8967d1a066a575e5d7"
    sha256 cellar: :any_skip_relocation, monterey:       "211cc03d78bd54a0a1bf6835d8cc84100fea2816dd870e05192b631426543347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7934fdc550f3e8c9bde597228a4adec1e637a7086c2a341e7655603134d4b7d6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end