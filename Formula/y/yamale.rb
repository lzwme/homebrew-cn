class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https:github.com23andMeYamale"
  url "https:files.pythonhosted.orgpackages0c933002a45542579cdd626a011f39bbe19ddcc1fbe0541081824c39ef216147yamale-4.0.4.tar.gz"
  sha256 "e524caf71cbbbd15aa295e8bdda01688ac4b5edaf38dd60851ddff6baef383ba"
  license "MIT"
  head "https:github.com23andMeYamale.git", branch: "master"

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_sonoma:   "537b215d7ace1197ab947adf9f74dddc1bfff996252d6cf1a576de7dd93c3473"
    sha256 cellar: :any,                 arm64_ventura:  "294ef10fd3d56aa2254e906a2de8b81ad8ae768499dfef026be01e84a62941c4"
    sha256 cellar: :any,                 arm64_monterey: "351d34280958b5f6184a619a5db348f142e9500bdbe966d3281e5da3222f372c"
    sha256 cellar: :any,                 sonoma:         "954bbc58163d984669dbea615002c36f0dcf731944042348b719ab1ad68ac616"
    sha256 cellar: :any,                 ventura:        "d4fe9a642e834e771ddeea3a43ad2d3784cccfc64b6d7d7101cd4a2c8e0f2081"
    sha256 cellar: :any,                 monterey:       "ed0cd3ab62fc753fbc6c4850af044abf4f64e3a3e55e19aef18516278065dc57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8562f639335608c5672873b912a2354d972516f0a435ddc90734d119ec7e7a"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
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