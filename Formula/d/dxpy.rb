class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/21/1c/674870249e045f330882e117ca25e6fc744f5b3be4c3a4d53c427546fd2c/dxpy-0.413.0.tar.gz"
  sha256 "dd2550622399594902d922db15c676388079f3c5c421f1be2bedad1145687c84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a020e559e7ed4017c980a7d25b5ab44087bda9559f31a76c82891fa45e15c2de"
    sha256 cellar: :any, arm64_sequoia: "854d3da4a7e10afade84e3c8edc128c5af7d2c957dfffd85cb8fa454ec91620d"
    sha256 cellar: :any, arm64_sonoma:  "0c2998e4a4b5a79f6e2c7450d6569da9e75ee2f15c6cbfbe21da04533b2bbd3e"
    sha256 cellar: :any, arm64_linux:   "e00b75781ae74d94fdc69446bc510588c9d3245febba584bc62a4c0504567daf"
    sha256 cellar: :any, x86_64_linux:  "e8852e1549925028a9fe7de8b70aacecd1dfc190d19cfba283403a6b616e845b"
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
    url "https://files.pythonhosted.org/packages/fd/d5/7bb52ee6dfcb36abfc787d5512c8d11fb231f1a7caac7c52479d98ed8dd6/awscrt-0.36.2.tar.gz"
    sha256 "6a6ad171cc3bb2763fb006c9c5c1c3df85d9c1d30b2ca0908ce539e5ee694629"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/b8/2a/1b7eadbd3c858204a90406a2a1e0dccd1592f69b77ec278a202fa325c50f/crc32c-2.9.tar.gz"
    sha256 "d6d2ae0299a417e5fb2e3641838cec34a23778a62fb4ce928792366476c1983b"
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