class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  # `mapproxy.org` is 404, upstream bug report, https:github.commapproxymapproxyissues983
  homepage "https:github.commapproxymapproxy"
  url "https:files.pythonhosted.orgpackagescf84c3f312ea9335c72631b98545472270057c4e099ad9048c6c170c5b8ff79dMapProxy-3.1.2.tar.gz"
  sha256 "1a6b790032d0e3330de43578069eee346d36c84e28a90a6a157b6c7c766b5ffe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5ed8d4100e10cc0e9ddcb034007f99fd1fcc75b033e5b0e71f1d57662d275f5"
    sha256 cellar: :any,                 arm64_sonoma:  "880bc61692eae449e97f542df4f315fe2d556daa29068abdff8dd0883a37540f"
    sha256 cellar: :any,                 arm64_ventura: "a0cdbf4ba93c1930a53fd0729f6188f95e439fe679a972cc723c231a58fc4981"
    sha256 cellar: :any,                 sonoma:        "fd3afa1a82d57c1b73e0a1ae88740f51612a7cc35474ae442f332fdd0b3152f3"
    sha256 cellar: :any,                 ventura:       "af5a9d2e2f9c65d3d9e73281a4ef90b9e6d008b066ca76ebc03b2b1167b32c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3935e4726bc7ee69ef340d44a1c70821bcf77974610f5e3a90e810dd9d9107e8"
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

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
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
    url "https:files.pythonhosted.orgpackages2380afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4frpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
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
    assert_predicate testpath"seed.yaml", :exist?
  end
end