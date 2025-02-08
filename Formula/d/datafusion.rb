class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https:arrow.apache.orgdatafusion"
  url "https:github.comapachearrow-datafusionarchiverefstags45.0.0.tar.gz"
  sha256 "9c75fb970ae0185f128530cd9edd28460e69053380ab43f50594881ff1249594"
  license "Apache-2.0"
  head "https:github.comapachearrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f61478b8823113b41e970b06de7408b6b04eeac767d9d138b1b9e3650342ed29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ffaf1ab294ab908aca066012b3c3b01d4c3e6f62d7445dde3c2c4f36387f212"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "797d6dae9e4b809afb6234f4e952ed45dbb897e1e9ef19c2315511089fc6e876"
    sha256 cellar: :any_skip_relocation, sonoma:        "98218cf2829100937e71950a7d5677f47ba50b5237bb1e2b66ca20de243bf30c"
    sha256 cellar: :any_skip_relocation, ventura:       "c71b08424228bd7a34ecfd070fc959826ce3808e843ecfacd14881073c978c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f9a6e56c3b09e3fa6727812ee8d5d4330fa786b4ba8479934fc6d757da187f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end