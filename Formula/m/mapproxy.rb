class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  # `mapproxy.org` is 404, upstream bug report, https:github.commapproxymapproxyissues983
  homepage "https:github.commapproxymapproxy"
  url "https:files.pythonhosted.orgpackagesbc457c1317f12ba83c61e368a1710c4df1b0486c19c91adf195283312e3c7537mapproxy-4.1.2.tar.gz"
  sha256 "637854b593ebb85a82e968c88dff5901d2c26e180559503be7c721e08020417b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "871f3c9a9482530ee759786e06aded116afc98029d4c86b205561ed29f1ecaba"
    sha256 cellar: :any,                 arm64_sonoma:  "07f2c0822115c174bab8a8554866839450f23bc8ea7b3ef0da9ffb9eee93cba7"
    sha256 cellar: :any,                 arm64_ventura: "85c355c56cf0f3115d99cb0f4e7a77fca23bccd5271f17aa62c5a5ab99cc2f83"
    sha256 cellar: :any,                 sonoma:        "111dbd46f8313ce3eb22264d177d55cb05b78ae99f37cb3aba2b5abfbaf2d411"
    sha256 cellar: :any,                 ventura:       "cb50e93811efc46a858ff0468bc7e5ee4d1e308835efc02918c846a1d90f185a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca806dd0e21f7d40e060bc36f5b07dcff23ee8a781da052bfbad65b6bc6397a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "630fb5e66fc85241899f06a7e3d79ae85610428969de3ae2c1d50733582f75f3"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.13"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackagesbfd31cf5326b923a53515d8f3a2cd442e6d7e94fcc444716e879ea70a0ce3177jsonschema-4.24.0.tar.gz"
    sha256 "0b4e8069eb12aedfa881333004bccaec24ecef5a8a6a4b6df142b2cc9599d196"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesbfce46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pyproj" do
    url "https:files.pythonhosted.orgpackages6710a8480ea27ea4bbe896c168808854d00f2a9b49f95c0319ddcbba693c8a90pyproj-3.7.1.tar.gz"
    sha256 "60d72facd7b6b79853f19744779abcd3f804c4e0d4fa8815469db20c9f640a47"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2fdb98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages8ca660184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages9f6983029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71ewerkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"mapproxy-util", "create", "-t", "base-config", testpath
    assert_path_exists testpath"seed.yaml"
  end
end