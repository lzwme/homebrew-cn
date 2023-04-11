class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-23.4.10.tgz"
  sha256 "546d931428fcb63c8737d7cae274f661722e6f15ca3177cf028ee88881458eca"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e183d38740c078d9e680c9666a57fb3fe307ef5b465dcfcde149a01b650cce7"
  end

  depends_on "openjdk"

  def install
    libexec.install "build/dist/vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    (testpath/"index.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>hi</title>
      </head>
      <body>
      </body>
      </html>
    EOS
    system bin/"vnu", testpath/"index.html"
  end
end