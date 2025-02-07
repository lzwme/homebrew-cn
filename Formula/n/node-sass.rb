class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.84.0.tgz"
  sha256 "046598b138ce2bf8d336deffffadd779158898990065bcdacea91db40bdae12d"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "ea68d45ee0f4d8c2001e3a12f4890c6363eb71dfad0e2dc8d0cc605c39887cf9"
    sha256                               arm64_sonoma:  "a2f4e6d2840f4b8d8b2c7120d1b4c7b97669c5b4a07b75a4c47c6c86696c7107"
    sha256                               arm64_ventura: "cdd8b249f4e16aabe775283ed16145bfeb5dc21efaeeb030d7ecec63528435a5"
    sha256                               sonoma:        "04df622990582bc5216b848903b1236b01e38a2733c845f9926353bbeef9769c"
    sha256                               ventura:       "3ae7c0be07127d04b3d771d40e8ad44ff77546e20157d61225ff4a9a4ad807b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9fc485c814cb6bca37b8087cb27476020df2a7315fde27492e3f2ad958a9af2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end