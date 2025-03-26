class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  # `mapproxy.org` is 404, upstream bug report, https:github.commapproxymapproxyissues983
  homepage "https:github.commapproxymapproxy"
  url "https:files.pythonhosted.orgpackages18b806d152b95be0d229d46778a9425488823a15bca88f60eaee127a53255f47mapproxy-4.0.1.tar.gz"
  sha256 "167cee557611815e2dc2ba3befec03441070e3596a9178905ba7ff506013b1e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "63f69fb179a341752ec328eab32712f9bcceed664afcb3b67f432d77763606a8"
    sha256 cellar: :any,                 arm64_sonoma:  "988536bb19f84b77d5bb64da854a401a3a0b740b5c8d23ea7761aa377ab5bf90"
    sha256 cellar: :any,                 arm64_ventura: "6a297ea5db8e0ee1cc53e3909af0cdbeecbe70e7dd873efcc04ee7440bc6f52c"
    sha256 cellar: :any,                 sonoma:        "d3967ecebc8ac946de72f69c7f52ebbc65ef7c94def318260b15e328e5174e50"
    sha256 cellar: :any,                 ventura:       "f7359f2270166947e6ee391dab53e33e6bb676efdc786ac3b61c915790a36931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b79e6e85a260cf01a25fac5930b5689c17413c6d98f78a4400b41e12cda7cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d04791be28125fd8419251d117db286768970262c2fa0badd17d010f615987"
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
    url "https:files.pythonhosted.orgpackages0a792ce611b18c4fd83d9e3aecb5cba93e1917c050f556db39842889fa69b79frpds_py-0.23.1.tar.gz"
    sha256 "7f3240dcfa14d198dba24b8b9cb3b108c06b68d45b7babd9eefc1038fdf7e707"
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