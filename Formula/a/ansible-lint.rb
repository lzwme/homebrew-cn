class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://ansible-lint.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/f3/2d/6f60d6f91089e96191da9518563d6d8e4d81c24bc85a5e8d0ce2980d24d0/ansible-lint-6.20.2.tar.gz"
  sha256 "13991d1cba5d69e704a0465b8d5f0e082c3c04e7664dedbbd2d9e4ebc6afd745"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a806fc4b2e2b2cdcd54c4d5060d3e424e51abc902076be95f9f56d2c1901e5aa"
    sha256 cellar: :any,                 arm64_ventura:  "79787de418da3d06b5f7ef0710ce2f7692389157337e1ee763b07ea976b651e3"
    sha256 cellar: :any,                 arm64_monterey: "23d13b7280b9cfaad2d96cf20c4aa296deb6e16a3109959f0f8065fb02142d97"
    sha256 cellar: :any,                 sonoma:         "6186b164532f009dda8c952f466ef78098873822bd75ba3d4041ef73269782e7"
    sha256 cellar: :any,                 ventura:        "a62c406ada8a1b0180fecc7e831bdb74336529b9d5da8081c8ec4af17e59d834"
    sha256 cellar: :any,                 monterey:       "56eb09ac1c5b38f7170240f52ec62f2d2b1cf0de67c6be177e71d14babb0eb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7263daf60335d9a0856399fa73217e2b5002e6b41f4a90428d44a5e9e4d0348"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for rpds-py
  depends_on "ansible"
  depends_on "black"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "yamllint"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/36/f9/42b44473cedbf977f8fe41e2b72ea47216f708c59bafc41ad6aa93c09a71/ansible-compat-4.1.10.tar.gz"
    sha256 "2be8c7b510d2e15eed1e9ef443209d67d9aec8f427026b88936d4535ff59863d"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/90/8b/34d174ce519f859af104c722fa30213103d34896a07a4f27bde6ac780633/bracex-2.4.tar.gz"
    sha256 "a27eaf1df42cf561fed58b7a8f3fdf129d1ea16a81e1fadd1d17989bc6384beb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/e4/43/087b24516db11722c8687e0caf0f66c7785c0b1c51b0ab951dfde924e3f5/jsonschema-4.19.1.tar.gz"
    sha256 "ec84cc37cfa703ef7cd4928db24f9cb31428a5d0fa77747b8b51a847458e0bbf"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/52/fa/31c7210f4430317c890ed0c8713093843442a98d8a9cafd0333c0040dda4/rpds_py-0.10.3.tar.gz"
    sha256 "fcc1ebb7561a3e24a6588f7c6ded15d80aec22c66a070c757559b57b17ffd1cb"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/27/fc/73edf1269fab4ae08ada602f4bf17b0a0428b3bf10574c2ea7331d73f87d/ruamel.yaml-0.17.33.tar.gz"
    sha256 "5c56aa0bff2afceaa93bffbfc78b450b7dc1e01d5edb80b3a570695286ae62b1"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/f6/a0/acafd85c7c0aead293a16a70a49aba20ba2af9478771370b2897eae6059c/subprocess-tee-0.4.1.tar.gz"
    sha256 "b3c124993f8b88d1eb1c2fde0bc2069787eac720ba88771cba17e8c93324825d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/51/13/62cb4a0af89fdf72db4a0ead8026e724c7f3cbf69706d84a4eff439be853/urllib3-2.0.5.tar.gz"
    sha256 "13abf37382ea2ce6fb744d4dad67838eec857c9f4f57009891805e0b5e123594"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/92/51/72ce10501dbfe508808fd6a637d0a35d1b723a5e8c470f3d6e9458a4f415/wcmatch-8.5.tar.gz"
    sha256 "86c17572d0f75cbf3bcb1a18f3bf2f9e72b39a9c08c9b4a74e991e1882a8efb3"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.11")
    %w[ansible black yamllint].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - name: Homebrew test
        hosts: all
        gather_facts: false
        tasks:
          - name: Ping
            ansible.builtin.ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end