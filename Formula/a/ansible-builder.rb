class AnsibleBuilder < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for building Ansible Execution Environments (Containers)"
  homepage "https://ansible-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/3c/d5/c94e86098107209a82de9401ec31413fabd4236af0be9427c57a5bdbf855/ansible_builder-3.1.0.tar.gz"
  sha256 "d2dc573e26a7bd5095e98aeb37ee9b00bc9f5005abea7147d74229c0f3426fcb"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "c72abbb4a0c0331cbd9933ac2c83c23264c995a5fd0b7a0cae035b3ab0f21f36"
    sha256 cellar: :any,                 arm64_sequoia: "ec921bbdc259d52d3504e33d8b4108866b2f9aef7a812361405f93d18b72db1a"
    sha256 cellar: :any,                 arm64_sonoma:  "563a697596985997fc9aefd5a46506fd530c4dc6bdf39b172ce8ed954f6976f8"
    sha256 cellar: :any,                 sonoma:        "1cc92ea51a30f59be651219380c6c95c81e933cf55d8152b017711a02368c1d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb39f4a98fe899a582a655adc10ae9c17c298abf194abd4dc06b1a259e7c8392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "579af0012cfe5b4b00dc464b6be7bc4b7e5ccfa853a4af4b587ed8e7a1299ff9"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "bindep" do
    url "https://files.pythonhosted.org/packages/e9/e4/fdefd8289e79f3a2f9f692f9ef64b0c835856dd023f335c96c8225e776cb/bindep-2.13.0.tar.gz"
    sha256 "df7564753e583033bb113338150d772540145b4d189a4801ec56a25b5ede5050"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "parsley" do
    url "https://files.pythonhosted.org/packages/06/52/cac2f9e78c26cff8bb518bdb4f2b5a0c7058dec7a62087ed48fe87478ef0/Parsley-1.3.tar.gz"
    sha256 "9444278d47161d5f2be76a767809a3cbe6db4db822f46a4fd7481d4057208d41"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/ad/8d/23253ab92d4731eb34383a69b39568ca63a1685bec1e9946e91a32fc87ad/pbr-7.0.1.tar.gz"
    sha256 "3ecbcb11d2b8551588ec816b3756b1eb4394186c3b689b17e04850dfc20f7e57"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_tmp = testpath/"tmp"
    (testpath/"execution-environment.yml").write <<~YAML
      ---
      version: 3
      images:
        base_image:
          name: quay.io/ansible/awx-ee:latest
      options:
        skip_ansible_check: True
    YAML

    system bin/"ansible-builder", "create", "-c", test_tmp,
      "--output-filename", "Containerfile",
      "--file", testpath/"execution-environment.yml"
    assert_path_exists test_tmp/"Containerfile"

    assert_match version.to_s, shell_output("#{bin}/ansible-builder --version")
  end
end