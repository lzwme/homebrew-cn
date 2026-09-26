class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/98/98/7f8504aa4b04172fb73e8226696349111a92221db85016e6baf4e258f319/dxpy-0.415.0.tar.gz"
  sha256 "62ca97b746e673da5428f0ab1cb2517aaed324173c340b1a2039dbdf5e3befd2"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1017ead52d46a0df63ffdba1d8a9fc986ab5b189c19b5702afcead82e76bd285"
    sha256 cellar: :any, arm64_tahoe:       "21a809007d49b3c0d6c841db88fd576ece54f151d51cbf0ec1dfea5aea34635b"
    sha256 cellar: :any, arm64_sequoia:     "9d8ad05f51a6893f8a079f0c205fdfd8e22fbf164d84dc9c2f3ee96f0fc49e12"
    sha256 cellar: :any, arm64_linux:       "34e1e4e79d2ab9d62be2d4d992128aae1de7e554f55013e745519b347f4f08cf"
    sha256 cellar: :any, x86_64_linux:      "e4dc6965901ee3f0f6779940987f04288441254394a955bef9c89614d936c1d4"
  end

  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-checksums"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"
  depends_on "s2n"

  on_macos do
    depends_on "aws-c-compression"
    depends_on "aws-c-sdkutils"
    depends_on "openssl@3"
  end

  conflicts_with "deno", because: "both install `dx` binaries"

  pypi_packages exclude_packages: %w[cryptography certifi websocket-client]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/bb/02/2a724318c05aa0e6e74e2537e3a841097ad2aeb737bdc27c6a74ce72358f/awscrt-0.36.4.tar.gz"
    sha256 "5b6a53f10e8dd060e7c0c91d063831137239c234877a6d1f03b277dfbac0c507"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/f6/07/b5fabe88654f5eded3e4b6d84cde572dd0280a7362a6a5b698bbd77be5df/crc32c-2.9.post0.tar.gz"
    sha256 "6a089e0340de8438e836a09e613c6b541675d0f3aa92b3fe34295aaba62f014f"
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
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  # Issue ref: https://github.com/dnanexus/dx-toolkit/pull/1530
  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"

    livecheck do
      skip "Skip until new release with v1.9.0+"
    end
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