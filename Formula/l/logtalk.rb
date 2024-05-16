class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https:logtalk.org"
  url "https:github.comLogtalkDotOrglogtalk3archiverefstagslgt3790stable.tar.gz"
  version "3.79.0"
  sha256 "cf864054c26e946b88ce850759596ea687a64d885689ffceb2b3c641a63d6e7f"
  license "Apache-2.0"

  livecheck do
    url "https:logtalk.orgdownload.html"
    regex(Latest stable version:.*?v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3155ff49e6968108290903d9b72e7926f33ae32c04a2d1079fb59fadd077376d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c159620794f1129c602d3400a78967e2d48dfda4716278bbdba8047ab65f2c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5f32f9376f87656292b516fd571e2309f9f8ac1a00b495976d3c01681f11eaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "59741b9f868feb8068d3f2211ccc59ee1f7c52d4f35b5ad7891c58c2d8432aaa"
    sha256 cellar: :any_skip_relocation, ventura:        "621f9a869ba5ad5b11f628a9f8af9a3c505ce2e019fddddbf3cff7fd856b4efc"
    sha256 cellar: :any_skip_relocation, monterey:       "5921e4ade92ae8413e373681b85eed03d131439d219bf74cc4d5ee6612bd697a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d29c6c91c57dbcd4db2f2ada37da1d889bfe75ec55de934d6d476bc6a11e340"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system ".install.sh", "-p", prefix }
  end
end