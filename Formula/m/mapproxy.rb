class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/3b/fd/c479dcd60e2afc4683b72efde5ec97f073ac2cc01f62d3b1f1f2b357d394/MapProxy-3.0.0.tar.gz"
  sha256 "72c9fa6b71eea6cf33d5857b24d5b543c5eb95aadd4c9201964afb4a22d8cad0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bcd63a62b32f9f443cdd1854107ef8f19bd6d8bbc824230a0747b96cc061da1d"
    sha256 cellar: :any,                 arm64_ventura:  "839c29bc45be462742b7405c51fe303fbe4cfa07693bf40c43cc8707b10f34e3"
    sha256 cellar: :any,                 arm64_monterey: "1b1a8df9a6cb8af9de93e9ef9df428c96cb27c9b840729a1d967f521fe46001d"
    sha256 cellar: :any,                 sonoma:         "d7c1dc5c2171f3c25446161a8f2f1ee5ca9fae8a034a8d9708db430d5a65731e"
    sha256 cellar: :any,                 ventura:        "14d4e676dd7d609e957fe97e58eb20515d0c9ce7984e6347550408305a75f906"
    sha256 cellar: :any,                 monterey:       "5af307fe27fb2f11ffd28df3570084a9f39c681a10f8f71cc07d9953c2586d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f93d9711058fe2dfb4143838997b4638b9cd6233d0286738c3a5a647104058"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
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
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
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