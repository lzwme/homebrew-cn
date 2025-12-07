class CloudflareCli4 < Formula
  include Language::Python::Virtualenv

  desc "CLI for Cloudflare API v4"
  homepage "https://github.com/cloudflare/python-cloudflare-cli4"
  url "https://files.pythonhosted.org/packages/77/fd/87b3e026dcee2a6b891f2b6c98b8f0bc98a175c4b731c046b528298c07c5/cloudflare_cli4-2.19.4.post3.tar.gz"
  sha256 "36efe09d188678e8c99e654b79162758594107342d11f88192423aa47fd6c0b8"
  license "MIT"
  revision 1
  head "https://github.com/cloudflare/python-cloudflare-cli4.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa04cd2a3ae3fdc9dd3cbf0a9a3295c5fa2846d57df976beec72c34463973995"
    sha256 cellar: :any,                 arm64_sequoia: "3398bc28eca4d4cccdd80233e99bb242181adc127d93c4b38255398a73a73870"
    sha256 cellar: :any,                 arm64_sonoma:  "2deb462777a50e07c046c661fb1c7ec597b7043a41017d708c853fa9e809220f"
    sha256 cellar: :any,                 sonoma:        "a237476724511c8e2329098171f2a4373d6e3f6d5d4c1702747ce26ca7d3bb8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e03a52b1b48582556e106b6cbac0865746981b69ee186337db8cfec295deba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f8bc83b78988b58754b9d7665ddae43673d8b8cace77f371aab046095c5c57"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".cloudflare/cloudflare.cfg").write <<~EOS
      [CloudFlare]
      email = BrewTestBot@example.com
      token = 00000000000000000000000000000000
      [Work]
      token = 00000000000000000000000000000000
    EOS

    output = shell_output("#{bin}/cli4 --profile Work /zones 2>&1", 1)
    assert_match "cli4: /zones - 6111 Invalid format for Authorization header", output
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/cli4 --version 2>&1", 1)
  end
end