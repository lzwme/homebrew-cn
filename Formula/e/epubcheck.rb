class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https:github.comw3cepubcheck"
  url "https:github.comw3cepubcheckreleasesdownloadv5.2.0epubcheck-5.2.0.zip"
  sha256 "a88fc7ec19df1eb1c27f50ceb5156772ef0b53e1c418f663c8d750bdbdd0f922"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9078e3e592f0c1f83908f3ce507216c6a4b68d585c2e572c4589eb4861df6d47"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexecjarname, "epubcheck"
  end
end