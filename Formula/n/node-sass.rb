class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.91.0.tgz"
  sha256 "2ad6b1deb110b26158fc6db6e0ed43429326510f9ff525714b73f6302ddb4780"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "d0b45e70605093365340ca5b0547e636c00abb85537a41b07d4ca01407121ed5"
    sha256                               arm64_sonoma:  "91b98f312fb4aaf637e9d37b5b76b2a3fcd00230a4493a11ae6c1a6bc8282791"
    sha256                               arm64_ventura: "d1c71a099974b6462cc30de6586e4520f1b7f9795fef5a7c125ab5030b0bce1f"
    sha256                               sonoma:        "46de78a79e605bc18cbc39f342bdb9d299e3469913191b7ca398ab8be0fe4a9c"
    sha256                               ventura:       "629695e0711420c9798954f40f23afea1e615f346a24e69bfb75340c8cda60d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f53d5cfd52529e627bd8c4ca77190ae7f5b93cd6c6aea74caf46e1b28c3eac3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4665bbd9612853c410385a20358f94ac58cb4c78dd7badd03587aedb475bb9b"
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