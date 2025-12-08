class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-25.12.7.tgz"
  sha256 "0670fc8896bb8d2c5f42d3137c294f9b255e18dead0295451a7e75aee0fc1764"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae8d0476b8b6e0a0c03061d832e1d228b6a82858980e7c5465d9fe268970f5bd"
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