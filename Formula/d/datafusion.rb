class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghfast.top/https://github.com/apache/datafusion/archive/refs/tags/50.2.0.tar.gz"
  sha256 "85e56f3931717333288bf0296f8d905420a7945261db0ea873b8b4bc92b204a4"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a43acd7c7074373b1248186b43902c066e12b79d1b46a1041a801c53a69de574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4606d1069a235693984a5a979f68107640c0874743526d6079d9a2731538d7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0811c114eeed8a62cdf850927d61a84786620d9b9a37db2511cc9a0201d7c1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "54c6f1447767aecbc47ab4435e42bb091d0a307cae74a7412a5cf079cfe7d2a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1430d527d08678a37ef3032990a38c70632f961eda33b4f0e4806994e92bb046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4cff02c3aa6e5d773490e73a4f41ab2233cd7e9aa410d860c89d27cfb4b747e"
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