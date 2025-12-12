class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.96.0.tgz"
  sha256 "8a4ef00bd9819bb4883e7ae19408f8813cb24804fe419294da237c4ccf8e538a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33f9562fb14640922c7df74530889db1677fe127eec4bef3c50f811fa3528278"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33f9562fb14640922c7df74530889db1677fe127eec4bef3c50f811fa3528278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33f9562fb14640922c7df74530889db1677fe127eec4bef3c50f811fa3528278"
    sha256 cellar: :any_skip_relocation, sonoma:        "820220a009bf8ff78edf52ca963d5aa88c7d0e4b9e8a3edf4f26d786427f6b55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f759d59dc71650cf541b2367b23a6cab3563007345065f357b724ebe6f2047d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e1a2da730392c37c9874da67af736e2d6c841339d27c7f5f44a5cc00b3ebb0"
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