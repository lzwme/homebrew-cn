class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/b1/74/603937164d84904f453544d9a930330f5c38b1252557a0595619d590207e/dxpy-0.405.0.tar.gz"
  sha256 "535474d22c8dec2beea46dc22128f55351d5eade3abfcab34df4449742b79008"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e048e0fc6d403c878898d34a8cb5e95ee5251284f0e25d2c8badaef6503c1496"
    sha256 cellar: :any,                 arm64_sequoia: "938c6efa6c45acaaf6a6b644569d9be5f1f96e9b297dd15dce9f8c6783d09bdf"
    sha256 cellar: :any,                 arm64_sonoma:  "4bf8c101cbc5ffd0194c31df7dbed236384e219e1edf6e6342f6bbc70d959371"
    sha256 cellar: :any,                 sonoma:        "64bbc96660e37d9bb9b48cd1f49275e7ccd49a0b5826cbfe010ec33bf9979345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d605ca35855a6fe04f95064a146748eafd2f8b59cd5c52dc2a44d9c0d5509a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f519b3b26b423249f255f39d5506b2ee66c0408719cbc2f3108857e7f589102c"
  end

  depends_on "cmake" => :build # for awscrt
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-c-sdkutils"
  depends_on "aws-checksums"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "openssl@3"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline" => :no_linkage
  end

  on_linux do
    depends_on "aws-lc"
    depends_on "s2n"
  end

  conflicts_with "deno", because: "both install `dx` binaries"

  pypi_packages exclude_packages: %w[cryptography certifi]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/f6/05/1697c67ad80be475d5deb8961182d10b4a93d29f1cf9f6fdea169bda88c3/awscrt-0.31.2.tar.gz"
    sha256 "552555de1beff02d72a1f6d384cd49c5a7c283418310eae29d21bcb749c65792"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"

    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end