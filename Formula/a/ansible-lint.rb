class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://ansible-lint.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/09/b5/841f5ae439a2a039c6045880042d6acd8a8e2fd4e2fb66bc706e321ecb59/ansible_lint-26.9.0.tar.gz"
  sha256 "cb3265888f30815de0dcf0964d34768b45c98bb4361eea7eb42c0342e81b51b4"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "09e49a17d7ac787ae214621959bc03b3889dd6fe4c7b3bd22f2daa99d42b03c2"
    sha256 cellar: :any, arm64_tahoe:       "ce4742670c128c893f7002ae73659c9710bdafea3fa7bfeea3db3094957dc189"
    sha256 cellar: :any, arm64_sequoia:     "5e484c8c3bd3ab8f85c7c7a27d309e9f7f45a323e4e71ad81d4cd8f578dbec8e"
    sha256 cellar: :any, arm64_linux:       "309db61db343b4439944f3d48f029c7518d8dd11893f47447a0f3d1a4211acef"
    sha256 cellar: :any, x86_64_linux:      "71d14cda97a1c55f51cbbd1b8bcbca53b449d6406440cc3747b2f192a8ec5424"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ansible" => :test
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["cryptography", "rpds-py"]

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/4c/bf/75ac51c0377ffe4863900a1ad4b2726c7cb664dd5da5c33c2c6b4fc3040a/ansible_compat-26.9.0.tar.gz"
    sha256 "e101649196e4fffc810c3f9f4f185107cc1e5be0ef26d38ad9c4abfa22b0b183"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/df/72/2152230f254bd9c6b892f95d6d291a96fd09b632ce01c6b406eda8c5cd75/ansible_core-2.21.4.tar.gz"
    sha256 "81a9329f4f12cfa5008dcab5d1bf23ae69b7effc08c0f00048ab2461147ae95a"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/c0/37/5628dd55bf2b34257fc7603f0fe97c40e3aaf24265f416a9c85c95ca1436/black-26.5.1.tar.gz"
    sha256 "dd321f668053961824bcc1be1cc1df748b2d7e4fa28086b08331e577b0100a73"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/ac/01/5f394b8bcd6e5b92f73130990960423bbb19711f906bd9fe9ea5557c667c/bracex-3.0.1.tar.gz"
    sha256 "4e38e32392e4a4780fe15d644bfc7c8514057cfc3861e060b11814ce829c25e4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/6f/38/88cd6eda96c40594a1e3da7d8b40f04bc40ace5a6aef9ac5cb407540f173/filelock-4.0.1.tar.gz"
    sha256 "fdefc3f3e87716d855ae2b732c1cfd521dd99799ef2b4d00e8c0d4dcdc7cc94b"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/dd/65804b0c2925a1c821a05502ea57517b69a073ff400d25ab9faa3a2cf012/platformdirs-4.11.12.tar.gz"
    sha256 "e8dc1cb58f1153fd7f61db1374317770baababec2480b37b8f01c6cc25b45267"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/1d/14/4669927e06631070edb968c78fdb6ce8992e27c9ab2cde4b3993e22ac7af/resolvelib-1.2.1.tar.gz"
    sha256 "7d08a2022f6e16ce405d60b68c390f054efcfd0477d4b9bd019cc941c28fad1c"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/d7/22/991efbf35bc811dfe7edcd749253f0931d2d4838cf55176132633e1c82a7/subprocess_tee-0.4.2.tar.gz"
    sha256 "91b2b4da3aae9a7088d84acaf2ea0abee3f4fd9c0d2eae69a9b9122a71476590"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/57/43/30e407989e313677dbb9d5f045f966549a7254834571e342eaa4b55cc67b/wcmatch-11.0.1.tar.gz"
    sha256 "1ea2b4fa678b8ca268253798d5963935df39132d47c3e241c0a0732224005e7d"
  end

  resource "yamllint" do
    url "https://files.pythonhosted.org/packages/28/a0/8fc2d68e132cf918f18273fdc8a1b8432b60d75ac12fdae4b0ef5c9d2e8d/yamllint-1.38.0.tar.gz"
    sha256 "09e5f29531daab93366bb061e76019d5e91691ef0a40328f04c927387d1d364d"
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
    ansible = formula_opt_bin("ansible")/"ansible"
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