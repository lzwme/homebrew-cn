class Yamale < Formula
  desc "Schema and validator for YAML"
  homepage "https:github.com23andMeYamale"
  url "https:files.pythonhosted.orgpackages0c933002a45542579cdd626a011f39bbe19ddcc1fbe0541081824c39ef216147yamale-4.0.4.tar.gz"
  sha256 "e524caf71cbbbd15aa295e8bdda01688ac4b5edaf38dd60851ddff6baef383ba"
  license "MIT"
  head "https:github.com23andMeYamale.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "404d1bf074ae3876f307c15f20fdcf76fc8da4870c8f8209f5efee926dfce31f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "665950773a91872245f05e1c3aea132a00756b3abf99bdba5ace95a98ad2bdfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8f7032ff030e55537375e0116353b2c4acecb6aec99fbfb62e73cd54578cfd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d2645261ce728d79e8fc0b79015e18ebf63e056002b5018549d73969248989b"
    sha256 cellar: :any_skip_relocation, ventura:        "d45347a4781a8ce0227a902cec6358806d419bf095a29823ab8cca99d22275df"
    sha256 cellar: :any_skip_relocation, monterey:       "6a6c1f346429835f3cd56e57f5de5ab996d838c237669d4a247f48e4a393a1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb2e3390440074a4388aa4c6cab0c97a593e6826917826cd0bb05f3e3623e71"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath"schema.yaml").write <<~EOS
      string: str()
      number: num(required=False)
      datetime: timestamp(min='2010-01-01 0:0:0')
    EOS
    (testpath"data1.yaml").write <<~EOS
      string: bo is awesome
      datetime: 2011-01-01 00:00:00
    EOS
    (testpath"some_data.yaml").write <<~EOS
      string: one
      number: 3
      datetime: 2015-01-01 00:00:00
    EOS
    output = shell_output("#{bin}yamale -s schema.yaml data1.yaml")
    assert_match "Validation success!", output

    output = shell_output("#{bin}yamale -s schema.yaml some_data.yaml")
    assert_match "Validation success!", output

    (testpath"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    output = shell_output("#{bin}yamale -s schema.yaml schema.yaml", 1)
    assert_match "Validation failed!", output
  end
end