class Shub < Formula
  include Language::Python::Virtualenv

  desc "Scrapinghub command-line client"
  homepage "https://shub.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/70/ad/b4fa99366cd3c8db8812438fb1e8b6f8a10b2935b0ee28ac238ade864a8f/shub-2.15.4.tar.gz"
  sha256 "abd656f488449a6f88084cfc6f0e5bf1e015377f9777a02f35ae5dd44179434a"
  license "BSD-3-Clause"
  revision 6
  head "https://github.com/scrapinghub/shub.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "4781bcf903876d3e70218937f589900ede7f534a4a893d67269763f3b06fda1a"
    sha256 cellar: :any,                 arm64_sequoia: "35143c65a8df1962740d601e836e5c7fb048062d0da643033faa27c043f74471"
    sha256 cellar: :any,                 arm64_sonoma:  "4a23c0592d955d8659b404cf6d1029d5c6757e77bad7e4dde9744b1579b50df6"
    sha256 cellar: :any,                 sonoma:        "13a95f502590f8f3bdcb7139ae48d30225ef480be2b0bd8b30be80cc8fb49c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041317ea0a08ec8982747b92db67afd59271c15de11b04c6f3841393fe87cb5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e394a7dd1d0efb9755239aeceb9c316e51e6bd83ca2701a00a7b542f03d99d71"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/c8/5a/b17e1e257d3e6f2e7758930e1256832c9ddd576f8631781e6a072914befa/retrying-1.4.2.tar.gz"
    sha256 "d102e75d53d8d30b88562d45361d6c6c934da06fab31bd81c0420acb97a8ba39"
  end

  resource "scrapinghub" do
    url "https://files.pythonhosted.org/packages/99/63/7fb80a7ae2e21f2cadadbf442bb8b3c7025bb9b055c873803c204d19b162/scrapinghub-2.5.0.tar.gz"
    sha256 "1c2324cca7c2d0d7a0d9c12e3270f4a158cc1b3a96a100e55d37c2154552a313"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/9c/97/6627aaf69c42a41d0d22a54ad2bf420290e07da82448823dcd6851de427e/tqdm-4.55.1.tar.gz"
    sha256 "556c55b081bd9aa746d34125d024b73f0e2a0e62d5927ff0e400e20ee0a03b9a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"shub", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shub version")

    assert_match "Error: Missing argument 'SPIDER'.",
      shell_output("#{bin}/shub schedule 2>&1", 2)
  end
end