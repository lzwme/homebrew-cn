class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/3f/8c/3d2efe475e9244bd45e3a776ea8207f34a9bb15caaa02f6c95e473b2ada2/principalmapper-1.1.5.tar.gz"
  sha256 "04cb9dcff0cc512df4714b3c4ea63a261001f271f95c8a453b2805290c57bbc2"
  license "AGPL-3.0-or-later"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57ab3bf7969b488a522d7f96422d51e71110655f862e4d66fd4756974346d98f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff16319ad2e6d138b2afcbf3ab96f0e8016a2cd807ac720e45dd979901481b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c30306569885d9e313a1e6a8854774439a32f8e5a55a03766268016b64d572da"
    sha256 cellar: :any_skip_relocation, sonoma:         "7347a0ae555a0794de92b822edfa7b4a59527235b857d3583c1a478833c5366c"
    sha256 cellar: :any_skip_relocation, ventura:        "f944f671ce9fab549323ef531c16b4f276d184cca6145fc800e18caf05a6a6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "4b43edf024ad756848f4ae9a139aecf6a5384324aa890924982ae5879706b50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20b7d3899889dd835192acf03e376bd9921b2eeed70d93210572aefab495a869"
  end

  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/42/30/e5e2126eca77baedbf51e48241c898d99784d272bcf2fb47f5a10360e555/botocore-1.31.65.tar.gz"
    sha256 "90716c6f1af97e5c2f516e9a3379767ebdddcc6cbed79b026fa5038ce4e5e43e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  # Support Python 3.10, remove on next release
  patch do
    url "https://github.com/nccgroup/PMapper/commit/88bad89bd84a20a264165514363e52a84d39e8d7.patch?full_index=1"
    sha256 "9c731e2613095ea5098eda7141ae854fceec3fc8477a7a7e3202ed6c751e68dc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end