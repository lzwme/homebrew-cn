class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://ansible-lint.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/24/50/3d0bb7e77aed2a66fce4b87aec249adb11070ef2025db1215b1c0fb14b51/ansible_lint-25.4.0.tar.gz"
  sha256 "f2f2b31ad199925b2343f660552fb9468970f16c2c5d57da9feae70ec4eeca7d"
  license all_of: ["MIT", "GPL-3.0-or-later"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "642f4902a31a0e5d45c88efcac49602303a17a8c4c0f62403f00fce3c7a3fe81"
    sha256 cellar: :any,                 arm64_sonoma:  "d11b8dfa6c6699e5fd43e3fa298743cee40c84da1ab602f0158ed799c3755419"
    sha256 cellar: :any,                 arm64_ventura: "a65351ec947ef99552591bfb33fa723f401ba44c251353a3ac6944c889bec19a"
    sha256 cellar: :any,                 sonoma:        "13fd577796f734d97a143bce6029b88b9264cc1c237b66b0ccba862fc16e73a7"
    sha256 cellar: :any,                 ventura:       "6bc7048c368889d9619b89942db106528fb8be0df1fa17c99765c8758c57b284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff6891f2febd7011e5ed4c4b21b7eb038ebbc8e7215db94e813699cc5f82cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5609c0b4eb161a087577223c1a298fb41cd9f5f60f56150d6e76c9e635bfb713"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for rpds-py
  depends_on "ansible" => :test
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/30/66/5ab513ccbc8a5820056ee06eab293591a3ed0908eff47e7d3447a4280e20/ansible_compat-25.5.0.tar.gz"
    sha256 "0b71052313596e128d2bf60166a1d2ac41c6d140a0ca97d56b878e3c23bfce42"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/4c/1e/c5d52171ae2b86689e3ef9e4f578c605a7f53a862d1e9fe8c254deb75fe1/ansible_core-2.18.6.tar.gz"
    sha256 "25bb20ce1516a1b7307831b263cef684043b3720711466bd9d4164e5fd576557"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/94/49/26a7b0f3f35da4b5a65f081943b7bcd22d7002f5f0fb8098ec1ff21cb6ef/black-25.1.0.tar.gz"
    sha256 "33496d5cd1222ad73391352b4ae8da15253c5de89b93a80b3e2c8d9a19ec2666"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/d6/6c/57418c4404cd22fe6275b8301ca2b46a8cdaa8157938017a9ae0b3edf363/bracex-2.5.post1.tar.gz"
    sha256 "12c50952415bfa773d2d9ccb8e79651b8cdb1f31a42f6091b804f6ba2b4a66b6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ce/10/f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6/resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/96/d2/7bed8453e53f6c9dea7ff4c19ee980fd87be607b2caf023d62c6579e6c30/rpds_py-0.25.0.tar.gz"
    sha256 "4d97661bf5848dd9e5eb7ded480deccf9d32ce2cd500b88a26acbf7bd2864985"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/d7/22/991efbf35bc811dfe7edcd749253f0931d2d4838cf55176132633e1c82a7/subprocess_tee-0.4.2.tar.gz"
    sha256 "91b2b4da3aae9a7088d84acaf2ea0abee3f4fd9c0d2eae69a9b9122a71476590"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/41/ab/b3a52228538ccb983653c446c1656eddf1d5303b9cb8b9aef6a91299f862/wcmatch-10.0.tar.gz"
    sha256 "e72f0de09bba6a04e0de70937b0cf06e55f36f37b3deb422dfaf854b867b840a"
  end

  resource "yamllint" do
    url "https://files.pythonhosted.org/packages/46/f2/cd8b7584a48ee83f0bc94f8a32fea38734cefcdc6f7324c4d3bfc699457b/yamllint-1.37.1.tar.gz"
    sha256 "81f7c0c5559becc8049470d86046b36e96113637bcbe4753ecef06977c00245d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources
    rm(bin/name)
    (bin/name).write_env_script libexec/"bin"/name, PATH: "#{libexec}/bin:${PATH}"
  end

  test do
    mkdir ".git"
    output = shell_output("#{bin}/ansible-lint --version 2>&1")
    refute_match "WARNING", output

    ansible_lint_core_version = output.match(/ansible-core:([\d.]+)/)[1]
    ansible = Formula["ansible"].opt_bin/"ansible"
    assert_match "[core #{ansible_lint_core_version}]", shell_output("#{ansible} --version")

    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~YAML
      ---
      - name: Homebrew test
        hosts: all
        gather_facts: false
        tasks:
          - name: Ping
            ansible.builtin.ping:
    YAML
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end