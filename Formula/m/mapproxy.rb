class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/a7/24/2c6e761c2552a92e2b68484fe528ed75d6a8a8ce432e8598325ebbcad27d/MapProxy-2.1.1.tar.gz"
  sha256 "8e1c391d2fc4c064ac8293962f44b5d639c600e1d26905b140099a2ff5127da3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f902861e14a348579142a0678deadc1e751cf66a3d3131a738e1a1d20f3bd70f"
    sha256 cellar: :any,                 arm64_ventura:  "86356cbb7d782607cc9d0224ff0a617b24752d3621d234d9ef3554c1a69c1f44"
    sha256 cellar: :any,                 arm64_monterey: "4bff006129836dfca2f0ec099bd3f3a8f70b432e56fc62704b8859081329d886"
    sha256 cellar: :any,                 sonoma:         "6b202ea7102c3405755699a32f01eacfd9ea282487a92e1a69bc5aca5c0a3bc6"
    sha256 cellar: :any,                 ventura:        "77bd647a6df9de6bd0f38f289c57bb665d89f61eca640b1c1f2e8aeb1e620aca"
    sha256 cellar: :any,                 monterey:       "a4649a08b4feb0390aac9f3506f8e8ce88ad60c3c5d46001851a9a7b75e5d827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e3b1270621cebce4b0187f8d519fb758f9754018b1c4c33bcda63dba85cd1c"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/c8/9d/6ee73859d6be81c6ea7ebac89655e92740296419bd37e5c8abdb5b62fd55/importlib_resources-6.4.0.tar.gz"
    sha256 "cdb2b453b8046ca4e3798eb1d84f3cce1446a0e8e7b5ef4efb600f19fc398145"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/7d/84/2b39bbf888c753ea48b40d47511548c77aa03445465c35cc4c4e9649b643/pyproj-3.6.1.tar.gz"
    sha256 "44aa7c704c2b7d8fb3d483bbf75af6cb2350d30a63b144279a09b75fead501bf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/36/a2/83c3e2024cefb9a83d832e8835f9db0737a7a2b04ddfdd241c650b703db0/rpds_py-0.19.0.tar.gz"
    sha256 "4fdc9afadbeb393b4bbbad75481e0ea78e4469f2e1d713a90811700830b553a9"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end