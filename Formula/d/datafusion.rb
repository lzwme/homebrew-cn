class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https:arrow.apache.orgdatafusion"
  url "https:github.comapachearrow-datafusionarchiverefstags42.1.0.tar.gz"
  sha256 "9b7e8a1b306de2a99f4223bd79180520b47689047405e757382b39fea72c4c48"
  license "Apache-2.0"
  head "https:github.comapachearrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bff93d29f5ab630525103345dbbc37073a5b82b9bfc2a264aa3a6fe040a35d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28cd8db5da9a5c6dbc4409c160ea41e4fbd1806b8ea69cd1acf25c79f921e3b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dce6b9f91c2d447040e30867a71dc1256ce34baf59a873bad4c84850b7539750"
    sha256 cellar: :any_skip_relocation, sonoma:        "99afe406d8375b42cba98bc8c4eef76b41b1cfa5133289f820847258260cf0c9"
    sha256 cellar: :any_skip_relocation, ventura:       "75db074f9550d307e8749c126219cb05f1a85c95c3a29096aecbb8362b07bf5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc098a830df6757e5725af17d3397a23ec91b3ce98733bc09624d82b99820d8"
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