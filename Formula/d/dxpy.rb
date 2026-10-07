class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/2a/9b/979fd7e0644dc270e91b165dc60c88fc885750aa7665d869ab7e3fd96e2d/dxpy-0.416.0.tar.gz"
  sha256 "d93bef77f30a4afcef32fba056c9624b6f0c73129360fa02089b7f51736f18a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "22f03c55f68f225d4d0e063177f5b34e4d1c98779352d2b19ded08c8c7e263c8"
    sha256 cellar: :any, arm64_tahoe:       "8fcb2f664175d520b80383acd60ae09242f17256fdccd25d81309c786e39c45b"
    sha256 cellar: :any, arm64_sequoia:     "b3f267377efdf89e1147a1466747206fe8e8fd113b653d779d5aa2d333e1c27a"
    sha256 cellar: :any, arm64_linux:       "6a5ca8f720e8d18a01db64079d428e18021f908086698a13093ed01cb536c2a1"
    sha256 cellar: :any, x86_64_linux:      "4e630fb80fdfe383f4574432cd2321f29fb9500cfaf0fedaf4f6d04b71b33e3f"
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
    # Avoid overlinking to aws-c-* indirect dependencies
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

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