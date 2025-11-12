class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.94.0.tgz"
  sha256 "6bc82e68ee40dd0ec22eb958fd45431c8ea0f53eee212a405c5e7be0595ca1ca"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9d5170aad8e89845e8475d9f64bb475856322fbb8e8355271b966178380b72a1"
    sha256                               arm64_sequoia: "f60d0cf7e3734ca31c265b6a1dc217870a8fa82d00a6f05a06ff0aeb3a59d3a2"
    sha256                               arm64_sonoma:  "f289d115489833cc3c989f04d807f23b31f3b7fe6d34f81ea68dc32ce269694a"
    sha256                               sonoma:        "3c6f49f72a386f4b03093740de2785d9814b25c731ee208cb97b9a5cf3de00ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c9dc62b6021c762fd0255ee1bcc4966548f386d91ce23d0341633712fdfa092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30b5f382ee6acdf788e3dcaf829c3ce771f4cb49f1dfc32c5695f6ad707c4034"
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