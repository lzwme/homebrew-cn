class Dolphie < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich top tool for monitoring MySQL"
  homepage "https://github.com/charles-001/dolphie"
  url "https://files.pythonhosted.org/packages/e3/cc/b84ae062535c88af2723188eed6ae82a046131df717849a66363cf6274db/dolphie-6.10.5.tar.gz"
  sha256 "64668b204cc32dcf09acb8c179bdeff1f3df658047848ac345f25cdedec2197c"
  license "GPL-3.0-or-later"

  no_autobump! because: "some resources have to be updated manually"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8c4757b98dbd21909cc26c9d18f6d680740c8ed739072a38972d8048b29f1c5"
    sha256 cellar: :any,                 arm64_sequoia: "df26fa16a390e432c1067d23423138a229f415c6cf5c63d6d1d503346171faac"
    sha256 cellar: :any,                 arm64_sonoma:  "79b69c744016e0f634ca015efd8ed71c970797c482a03df334c9c5414786f527"
    sha256 cellar: :any,                 sonoma:        "5fc9487b70318bf5c9a2a54cacc8911e0cf449077a4c8870833c54d4ac54fbbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1491e3215ad48d01ab8434f2a3be701fa45c865fa1778f9d7bb9e1047485caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83df552221cbf7d9794d4c95a8d731db25132c2d56174b179c4d5a4bd38100f6"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "cryptography"]

  # `tree-sitter-*` sdists are missing C headers and therefore we have to use GitHub sources
  # Resources can be updated the following way:
  # 1. remove all resources to GitHub sources
  # 2. run `brew update-python-resources dolphie`
  # 3. replace `tree-sitter-*` resources with their versions from GitHub

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/3a/05/a1dae3dffd1116099471c643b8924f5aa6524411dc6c63fdae648c4f1aca/loguru-0.7.3.tar.gz"
    sha256 "19480589e77d47b8d85b2c827ad95d49bf31b0dcde16593892eb51dd18706eb6"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "myloginpath" do
    url "https://files.pythonhosted.org/packages/21/30/9acf030d204770c1134e130e8eb1293ce5ecd6a72046aaca68fbd76ead00/myloginpath-0.0.4.tar.gz"
    sha256 "c44b8d11e8f35a02eeac4b88bf244203c09cc496bfa19ce99a79561c038f9d09"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/c6/fe/ed708782d6709cc60eb4c2d8a361a440661f74134675c72990f2c48c785f/orjson-3.11.4.tar.gz"
    sha256 "39485f4ab4c9b30a3943cfe99e1a213c4776fb69e8abd68f66b83d5a0b0fdc6d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "plotext" do
    url "https://files.pythonhosted.org/packages/c9/d7/f75f397af966fe252d0d34ffd3cae765317fce2134f925f95e7d6725d1ce/plotext-5.3.2.tar.gz"
    sha256 "52d1e932e67c177bf357a3f0fe6ce14d1a96f7f7d5679d7b455b929df517068e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/cd/ec/7b8e6b9b1d22708138630ef34c53ab2b61032c04f16adfdbb96791c8c70c/psutil-7.1.2.tar.gz"
    sha256 "aa225cdde1335ff9684708ee8c72650f6598d5ed2114b9a7c5802030b1785018"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/f5/ae/1fe3fcd9f959efa0ebe200b8de88b5a5ce3e767e38c7ac32fb179f16a388/pymysql-1.1.2.tar.gz"
    sha256 "4961d3e165614ae65014e361811a724e2044ad3ea3739de9903ae7c21f539f03"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/e5/40/edede8dd6977b0d3da179a342c198ed100dd2aba4be081861ee5911e4da4/sqlparse-0.5.3.tar.gz"
    sha256 "09f67787f56a0b16ecdbde1bfc7f5d9c3371ca683cfeaa8e6ff60b4807ec9272"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/ba/ce/f0f938d33d9bebbf8629e0020be00c560ddfa90a23ebe727c2e5aa3f30cf/textual-5.3.0.tar.gz"
    sha256 "1b6128b339adef2e298cc23ab4777180443240ece5c232f29b22960efd658d4d"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/66/7c/0350cfc47faadc0d3cf7d8237a4e34032b3014ddf4a12ded9933e1648b55/tree-sitter-0.25.2.tar.gz"
    sha256 "fe43c158555da46723b28b52e058ad444195afd1db3ca7720c59a254544e9c20"
  end

  resource "tree-sitter-bash" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-bash/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "9d6bad618e712b51ff060515b0ce6872e33727148f35becb8aa3ad80044c2348"
  end

  resource "tree-sitter-css" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-css/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "03965344d8c0435dc54fb45b281578420bb7db8b99df4d34e7e74105a274cb79"
  end

  resource "tree-sitter-go" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-go/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "2dc241b97872c53195e01b86542b411a3c1a6201d9c946c78d5c60c063bba1ef"
  end

  resource "tree-sitter-html" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-html/archive/refs/tags/v0.23.2.tar.gz"
    sha256 "21fa4f2d4dcb890ef12d09f4979a0007814f67f1c7294a9b17b0108a09e45ef7"
  end

  resource "tree-sitter-java" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-java/archive/refs/tags/v0.23.5.tar.gz"
    sha256 "cb199e0faae4b2c08425f88cbb51c1a9319612e7b96315a174a624db9bf3d9f0"
  end

  resource "tree-sitter-javascript" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-javascript/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "9712fc283d3dc01d996d20b6392143445d05867a7aad76fdd723824468428b86"
  end

  resource "tree-sitter-json" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-json/archive/refs/tags/v0.24.8.tar.gz"
    sha256 "acf6e8362457e819ed8b613f2ad9a0e1b621a77556c296f3abea58f7880a9213"
  end

  resource "tree-sitter-markdown" do
    url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.1.tar.gz"
    sha256 "acaffe5a54b4890f1a082ad6b309b600b792e93fc6ee2903d022257d5b15e216"
  end

  resource "tree-sitter-python" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-python/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "4609a3665a620e117acf795ff01b9e965880f81745f287a16336f4ca86cf270c"
  end

  resource "tree-sitter-regex" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-regex/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "853200795c4cf856eba9de3f4f9abb370d22aef4fb32e8911e210bb7e4253087"
  end

  resource "tree-sitter-rust" do
    url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-rust/archive/refs/tags/v0.24.0.tar.gz"
    sha256 "79c9eb05af4ebcce8c40760fc65405e0255e2d562702314b813a5dec1273b9a2"
  end

  resource "tree-sitter-sql" do
    url "https://ghfast.top/https://github.com/DerekStride/tree-sitter-sql/releases/download/v0.3.11/tree-sitter-sql-v0.3.11.tar.gz"
    sha256 "a97a324eae9c81ed68f6e162b9b33f8911fc6442caa2950e57c498e2460d1387"
  end

  resource "tree-sitter-toml" do
    url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-toml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "7d52a7d4884f307aabc872867c69084d94456d8afcdc63b0a73031a8b29036dc"
  end

  resource "tree-sitter-xml" do
    url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-xml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "4330a6b3685c2f66d108e1df0448eb40c468518c3a66f2c1607a924c262a3eb9"
  end

  resource "tree-sitter-yaml" do
    url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-yaml/archive/refs/tags/v0.7.2.tar.gz"
    sha256 "aeaff5731bb8b66c7054c8aed33cd5edea5f4cd2ac71654f3f6c2ba2073d8fac"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/ed/f6/2ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1/zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    # Fails in Linux CI with "ParseError: end of file reached"
    # See https://github.com/Homebrew/homebrew-core/pull/152912#issuecomment-1787257320
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/dolphie mysql://user:password@host:port 2>&1")
    assert_match "Invalid URI: Port could not be cast to integer value as 'port'", output

    assert_match version.to_s, shell_output("#{bin}/dolphie --version")
  end
end