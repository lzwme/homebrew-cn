class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https://github.com/zephyrproject-rtos/west"
  url "https://files.pythonhosted.org/packages/f5/5f/703817873bacfa4b1f796b1b6da5df7a26033d57a2e307b1d6f9c94344a9/west-1.1.0.tar.gz"
  sha256 "e3487f54b6bd904580489b603ef1a6e099c6f2e656014c2b83c4b3c2175fa4df"
  license "Apache-2.0"
  head "https://github.com/zephyrproject-rtos/west.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bcc0276be418767d679ac8e471233e2ce704523d217dc33305b7acd2c9442ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12730e2db9b91b4c4648e45a4cead960c355e55c368f7151a13b63aa39cf8314"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d4b5806166ff6c9d55ea797b5b0e9116d9b7680d20d6da8b42baab9f469ce89"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaea62f5290a3129f7de51a32787c54000a7fbfd4e3903b5bda6886716b12139"
    sha256 cellar: :any_skip_relocation, ventura:        "43b4e25782c07a955667f5e3dc2151770cb154ac824b799a966116b4e368904a"
    sha256 cellar: :any_skip_relocation, monterey:       "863f4084c84660e25c52a77f1017b613a8bbb6514604c78c4ea17003dcc152b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc890a60524bd150078685403ef4783b0aa679f4a6951acc48533b6e31691291"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/97/03674459c459b9b69ef71eba039205a72867e5c6c409df3136858f6836f3/ruamel.yaml-0.17.31.tar.gz"
    sha256 "098ed1eb6d338a684891a72380277c1e6fc4d4ae0e120de9a447275056dda335"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/"west" do
      mkdir "test-project"
      (testpath/"west/test-project/west.yml").write <<~EOS
        manifest:
          self:
            path: test-project
      EOS
      system bin/"west", "init", "-l", testpath/"west/test-project"
      assert_predicate testpath/"west/.west", :exist?
    end
  end
end