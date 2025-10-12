class Reuse < Formula
  include Language::Python::Virtualenv

  desc "Tool for copyright and license recommendations"
  homepage "https://reuse.software"
  url "https://files.pythonhosted.org/packages/76/b0/ffd3a8978504763982db4735b7d87fc16b57f4b511c49a38ca25a7cb9ad3/reuse-6.1.2.tar.gz"
  sha256 "6019a75f4ca18ad5b2506e0f3ec1b926b27ba6cdc9da88492e7fc65e3ff12c39"
  license all_of: [
    "GPL-3.0-or-later",
    "CC-BY-SA-4.0",
    "CC0-1.0",
    "Apache-2.0",
  ]
  head "https://github.com/fsfe/reuse-tool.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c7e5c081299f2dd99f9cded9533b1d98339ade2673b0fa8c28b095eeacb9361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28e31ac3a0ee28ecbb84930ca144f59133378bbf9f3b5d199ec615d014597c6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a281177f4bf74c2534f5c1350c4c8a1ebab59d8d23c43540b1498df5abdd0784"
    sha256 cellar: :any_skip_relocation, tahoe:         "a60277164c86579bca503ba8322549189f99f507860ef7bdf94b5c954ef87309"
    sha256 cellar: :any_skip_relocation, sequoia:       "b54e219e36a2c5f093c7c2670e6e69dc45604f01d7c7c44f3d444609dd363949"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a8552c732cb24fbd5005fd9f128fefd585146797078c809d548f988eb35b0be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dd1d69e6c909adff9279a409da8db1d0d71916ced211d6b18904722247bec51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14d0ae994487a1048854811fdf7604e9758bd19794b2ee8317e0c39d69d51773"
  end

  depends_on "python@3.14"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "python-debian" do
    url "https://files.pythonhosted.org/packages/bf/4b/3c4cf635311b6203f17c2d693dc15e898969983dd3f729bee3c428aa60d4/python-debian-1.0.1.tar.gz"
    sha256 "3ada9b83a3d671b58081782c0969cffa0102f6ce433fbbc7cf21275b8b5cc771"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"reuse", shell_parameter_format: :click)
  end

  test do
    (testpath/"testfile.rb").write ""
    system bin/"reuse", "annotate", "--copyright=Homebrew Maintainers",
                  "--exclude-year",
                  "--license=BSD-2-Clause",
                  testpath/"testfile.rb"
    header = <<~RUBY
      # SPDX-FileCopyrightText: Homebrew Maintainers
      #
      # SPDX-License-Identifier: BSD-2-Clause
    RUBY
    assert_equal header, (testpath/"testfile.rb").read
    system bin/"reuse", "download", "BSD-2-Clause"
    assert_path_exists testpath/"LICENSES/BSD-2-Clause.txt"
  end
end