class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.97.0.tgz"
  sha256 "3464d18791528f0599d1aaa6fe33521fa2df06cb28ce5eccf7c5c8d41bf91035"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11f773bf45854e9d856c71a3b5f9ec81c9f67d252f561f69d8d963d1b0f14f83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f773bf45854e9d856c71a3b5f9ec81c9f67d252f561f69d8d963d1b0f14f83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11f773bf45854e9d856c71a3b5f9ec81c9f67d252f561f69d8d963d1b0f14f83"
    sha256 cellar: :any_skip_relocation, sonoma:        "013202a7130cc3eca52dbcb00a52e59fa8fdbc411f85b0f2c2445bf161665419"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ef951b9fd35a1e5e11d7063869875e90fe631c5f67818c1aaa5136844af9e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea3225dfbfa72746ce60fb894a4d0e99763e35fd40bc838e4c8bda1a0e5e643"
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