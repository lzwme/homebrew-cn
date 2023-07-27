class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://www.linode.com/products/cli/"
  url "https://files.pythonhosted.org/packages/87/9a/e4d3fa5d8e2191a18b6aa9960a89ef8e3713edf8fcdeeb86e8cab6ac17e6/linode-cli-5.41.3.tar.gz"
  sha256 "03f23c34255881f7124f40a2d699556beefba196d4049429fa97bdfb9370a0b4"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc367cc2e6728e6d054a5a4632c66da9cfe8822ed50430c502490bd3f553ae25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "404260fa52f4457149494fcb9154be5214ae1f3dc5340259a4d908bbf011c822"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d347bfd946b8864ef681394c980685534b57b52cc69ba87b550fc95bbb2c03a2"
    sha256 cellar: :any_skip_relocation, ventura:        "1d59464706c75886a0b444e328fdfd83c20e0e1f319bd9a28bfd9896e7f019b5"
    sha256 cellar: :any_skip_relocation, monterey:       "86ba8b384f478d8a08cfa62e5757435d1378aed021311dfb4e80aa219ba92bf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bef3d4523db38117c74ba54575e7a4a204355e50aa873c966ed9fb953b283be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa339d3b6d069a2d55b58961c7e2f2431dbd5faa87303051d1a8e2b9a92b3c61"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "linode-api-spec" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/linode/linode-api-docs/refs/tags/v4.159.0/openapi.yaml"
    sha256 "a4761d7bb1b995fe88c3e4bc592ab1465c6eae6ec448186097f9fcc9a2920acb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11", system_site_packages: false)
    venv.pip_install resources.reject { |r| r.name == "linode-api-spec" }
    buildpath.install resource("linode-api-spec")

    # The bake command creates a pickled version of the linode-cli OpenAPI spec
    system libexec/"bin/python3", "-m", "linodecli", "bake", "./openapi.yaml", "--skip-config"
    # Distribute the pickled spec object with the module
    cp "data-3", "linodecli"

    inreplace "setup.py" do |s|
      s.gsub! "version=version,", "version='#{version}',"
      # Prevent setup.py from installing the bash_completion script
      s.gsub! "data_files=get_baked_files(),", ""
    end

    bash_completion.install "linode-cli.sh" => "linode-cli"

    venv.pip_install_and_link buildpath
  end

  test do
    require "securerandom"
    random_token = SecureRandom.hex(32)
    with_env(
      LINODE_CLI_TOKEN: random_token,
    ) do
      json_text = shell_output("#{bin}/linode-cli regions view --json us-east")
      region = JSON.parse(json_text)[0]
      assert_equal region["id"], "us-east"
      assert_equal region["country"], "us"
    end
  end
end