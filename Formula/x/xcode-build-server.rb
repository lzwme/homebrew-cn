class XcodeBuildServer < Formula
  include Language::Python::Shebang

  desc "Build server protocol implementation for integrating Xcode with sourcekit-lsp"
  homepage "https:github.comSolaWingxcode-build-server"
  url "https:github.comSolaWingxcode-build-serverarchiverefstagsv1.0.1.tar.gz"
  sha256 "9c4647e6e21b9de1f10aeae6b7c119e6df8acce603dab1be258326bd45acf5c6"
  license "MIT"
  head "https:github.comSolaWingxcode-build-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a878f5aecb890e0175fd9c373c59de27a91d289bc3bab1f86dc153d91b6ddc02"
  end

  depends_on "gzip"
  depends_on :macos
  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]

    rewrite_shebang detected_python_shebang, libexec"xcode-build-server"
    bin.install_symlink libexec"xcode-build-server"
  end

  test do
    system "#{bin}xcode-build-server", "--help"
  end
end