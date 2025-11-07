class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://ansible-lint.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/17/dd/6c1dd87464488a8d848d3e9dc5b833f0328ce9b4b7fcb6511a702d4cf0cd/ansible_lint-25.9.2.tar.gz"
  sha256 "0eea8a5d17dd328bef12e7c9b6eb8714ba03fb1af62d9c700bf46e4858d1a6a4"
  license all_of: ["MIT", "GPL-3.0-or-later"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2091feb0f5470d821d4c12e08f29870c6efe6e6fee90921d66a14d2fdaae9501"
    sha256 cellar: :any,                 arm64_sequoia: "fa7ff6da1f9c4dc26403e34291bd1d0d952b4ab2d2725306235de83390e71a98"
    sha256 cellar: :any,                 arm64_sonoma:  "955a14c29f2fc5518abe48d8de0907596c3408b7f0e0c368ce298224ffc50cf9"
    sha256 cellar: :any,                 sonoma:        "8bfe9f983b29d2d5b1a405c707bc249548895722cb852ead87107e4e289500cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd997ec1c112a83742e71316f300582fbcfa064eba9251e7cda04c7fca33a8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc4b54ca69b2fb967ee1bce3803f0fc1b058354e42e79d63f20fd7fbfe4ceb33"
  end

  depends_on "pkgconf" => :build
  depends_on "ansible" => :test
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["cryptography", "rpds-py"]

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/e3/06/5e66f1f0d482b21b0dc03c9b9e47cab58dd4efc770f41029bb244e86b608/ansible_compat-25.8.2.tar.gz"
    sha256 "c5ae1ff70938f1e009cfc7df66c9faad223a3ccd0ad6b57400de53b2459a6164"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/6b/ef/35f14c0d8877f6ed233c4a03f5bc161b88342e97dec3e8e04f418f28136f/ansible_core-2.19.4.tar.gz"
    sha256 "888db6593f2fd42cd05bdbe546704d9c969dce99e3373a54498f6dbefcfa1917"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/4b/43/20b5c90612d7bdb2bdbcceeb53d588acca3bb8f0e4c5d5c751a2c8fdd55a/black-25.9.0.tar.gz"
    sha256 "0474bca9a0dd1b51791fcc507a4e02078a1c63f6d4e4ae5544b9848c7adfb619"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/63/9a/fec38644694abfaaeca2798b58e276a8e61de49e2e37494ace423395febc/bracex-2.6.tar.gz"
    sha256 "98f1347cd77e22ee8d967a30ad4e310b233f7754dbf31ff3fceb76145ba47dc7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
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
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
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
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/4e/8d/a762be14dae1c3bf280202ba3172020b2b0b4c537f94427435f19c413b72/pytokens-0.3.0.tar.gz"
    sha256 "2f932b14ed08de5fcf0b391ace2642f858f1394c0857202959000b68ed7a458a"
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
    url "https://files.pythonhosted.org/packages/9f/c7/ee630b29e04a672ecfc9b63227c87fd7a37eb67c1bf30fe95376437f897c/ruamel.yaml-0.18.16.tar.gz"
    sha256 "a6e587512f3c998b2225d68aa1f35111c29fad14aed561a26e73fab729ec5e5a"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d8/e9/39ec4d4b3f91188fad1842748f67d4e749c77c37e353c4e545052ee8e893/ruamel.yaml.clib-0.2.14.tar.gz"
    sha256 "803f5044b13602d58ea378576dd75aa759f52116a0232608e8fdada4da33752e"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/d7/22/991efbf35bc811dfe7edcd749253f0931d2d4838cf55176132633e1c82a7/subprocess_tee-0.4.2.tar.gz"
    sha256 "91b2b4da3aae9a7088d84acaf2ea0abee3f4fd9c0d2eae69a9b9122a71476590"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/79/3e/c0bdc27cf06f4e47680bd5803a07cb3dfd17de84cde92dd217dcb9e05253/wcmatch-10.1.tar.gz"
    sha256 "f11f94208c8c8484a16f4f48638a85d771d9513f4ab3f37595978801cb9465af"
  end

  resource "yamllint" do
    url "https://files.pythonhosted.org/packages/46/f2/cd8b7584a48ee83f0bc94f8a32fea38734cefcdc6f7324c4d3bfc699457b/yamllint-1.37.1.tar.gz"
    sha256 "81f7c0c5559becc8049470d86046b36e96113637bcbe4753ecef06977c00245d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
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