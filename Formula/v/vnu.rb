class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-26.2.6.tgz"
  sha256 "a28e107f00d1d2dceb5a6857e90db36c92b4e387d0480dec70bae5cbc46d16eb"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af52ef95590afd4c056d53819d98e1b39dd9e028a7be60b69b0f15d909e332eb"
  end

  depends_on "openjdk"

  def install
    libexec.install "build/dist/vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    (testpath/"index.html").write <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>hi</title>
      </head>
      <body>
      </body>
      </html>
    HTML
    system bin/"vnu", testpath/"index.html"
  end
end