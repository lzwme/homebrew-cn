class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  # `mapproxy.org` is 404, upstream bug report, https:github.commapproxymapproxyissues983
  homepage "https:github.commapproxymapproxy"
  url "https:files.pythonhosted.orgpackages203772c3bd2a68d753c595cc15d781b6300d882bfa959ab6b73f20e6e194c2b4MapProxy-3.1.0.tar.gz"
  sha256 "a473f5554723d89b04186a41ee15f8463d135bc41ade53f885228d7e5774f1c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2a5388e5b7dd9c1bd08d0ce6ed9a9520ad085b2c9c39c23ad467413ad4fb440"
    sha256 cellar: :any,                 arm64_sonoma:  "1ca2578919d1c9373c675403450fa5480af2d7f76b6a57f4a8574b4af454c17e"
    sha256 cellar: :any,                 arm64_ventura: "7fd3bbbf8eda2c887a0d783783dbd82f0134cefb7af5d4b46bf9aa4ea9ba225b"
    sha256 cellar: :any,                 sonoma:        "bad40127f6dae06e1c819e19555a870ccf209d5e675bd8cc0df294992a0f741a"
    sha256 cellar: :any,                 ventura:       "bf67be50e86b2cfe15016aeb493c8dd41edbcf9320e9d9899f3aadcccc749503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93e509f3f757a65da2787796550a66f43d1944a3507300ba927fb6dd9750a2f7"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.13"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "pyproj" do
    url "https:files.pythonhosted.orgpackages47c20572c8e31aebf0270f15f3368adebd10fc473de9f09567a0743a3bc41c8dpyproj-3.7.0.tar.gz"
    sha256 "bf658f4aaf815d9d03c8121650b6f0b8067265c36e31bc6660b98ef144d81813"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages5564b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29arpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages1027a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath"seed.yaml", :exist?
  end
end