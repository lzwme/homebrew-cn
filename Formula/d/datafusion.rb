class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghfast.top/https://github.com/apache/datafusion/archive/refs/tags/52.2.0.tar.gz"
  sha256 "158ab24d83280830fa7e84ea37b59c2334fed3f1d1b4614d20d9d98799f9a01f"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cefdb0fc03f92aa33cd74f66c242dd33d1d2d944544dd9dc1856ec7f7da2611"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df1109f1bab353534de36cfe2368ee2554c84be0ce7a6b0558eeb5010d4252d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e5579aeca35e20a27b24fcf335e1dc1980c1d4aef04f076d33359a6f03f5d21"
    sha256 cellar: :any_skip_relocation, sonoma:        "098e26ada2aa3f3ed95a297b768e25e5e3968befbbb69a195c48be0fb28d62e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "341b62d626ba91f6e117a698b5c75b7bed83a9f5fba4c89589a692a2531483a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9953b96ccc3d3b3f0ef66d8c2f1c550feaa561aca09c40dc13893b8b0a404f4b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end