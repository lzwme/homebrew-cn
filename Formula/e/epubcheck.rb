class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https:github.comw3cepubcheck"
  url "https:github.comw3cepubcheckreleasesdownloadv5.1.0epubcheck-5.1.0.zip"
  sha256 "74a59af8602bf59b1d04266a450d9cdcb5986e36d825adc403cde0d95e88c9e8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "428ebaaad5e60ee30519da9e99bad248d757684fe2bd7a2eed54ad36e4b3992e"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexecjarname, "epubcheck"
  end
end