class Shellshare < Formula
  include Language::Python::Shebang

  desc "Live Terminal Broadcast"
  homepage "https:github.comvitorbaptistashellshare"
  url "https:github.comvitorbaptistashellsharearchiverefstagsv1.1.0.tar.gz"
  sha256 "0a102c863f60402ab48908563edde38450add0ae02454360fa94065824a61907"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "74bd14d6127d61de20dc99c0936450669eb5bbe22788f0ef64abdcacf2c1f7a0"
  end

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "publicbinshellshare"
    bin.install "publicbinshellshare"
  end

  test do
    system bin"shellshare", "-v"
  end
end