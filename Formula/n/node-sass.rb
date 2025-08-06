class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.90.0.tgz"
  sha256 "10aeed34cfaae9bce8387fb81610a02fbf7ccaa20d6e7c3a988308bcd87c3375"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "fd1c8793f2429198051949111422c9cf6e6789b816cc4467135b307680a4e25e"
    sha256                               arm64_sonoma:  "b8c41670c6830f0c23c4e162aa0ec5431de478c4109711fcb5f2d0d441743654"
    sha256                               arm64_ventura: "d557f9c3109850aab495b1302efa65cb58579631d413154bee6e974a0e365dee"
    sha256                               sonoma:        "887d88e5f41572d242563b5c2bc0c8192b18218e0eef27cf8ae98b54f31909e4"
    sha256                               ventura:       "ad307b90917ff35097ab28eb01994639875c5e8f050fae55b0f3a7294e554ccd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feb11aebdb7ab7a134808f9208021e7c6b5075ac692079861482e9d8182b431d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "722a374a6dd194bdb4aa24ac1bb1bc779324f419e6370c58358937094aedb3f6"
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