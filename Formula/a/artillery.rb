require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.18.tgz"
  sha256 "07db28ec1b81c48e85f52f0d4dd29aeee821d1deb34cb0ff3806baf696e9a5fb"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "eb15df988d35341d9b0b223a8ae6e6a5dfacb4238d403affa72a2e3e53dbdb99"
    sha256                               arm64_ventura:  "a53880d3351cd2d1352bf41701ce5a39c5cdfe7f04f1a7397276aaf15c95b4f1"
    sha256                               arm64_monterey: "0ebd71c1a45f2ba692a9b581a81f36ffc39560ffa9f7ed144d169ba98242cd91"
    sha256                               sonoma:         "9727e18098ae065506ca4346f774b46e423b77b02f53843644ce653f6973aa62"
    sha256                               ventura:        "ffe68b87a916bde46bc1a0eee6a6ad39d4aaf59c40ffb815c9ee08b63b8aae21"
    sha256                               monterey:       "67adb2b851ef56caf48f004eb2b1adca4c6ce18cf7a4af0b029477da9f3c3f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c143fa78843ebeeaed8546d776a488120b064f77d47a441aa7cb83383d683c"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"artillery", "dino", "-m", "let's run some tests!"

    (testpath/"config.yml").write <<~EOS
      config:
        target: "http://httpbin.org"
        phases:
          - duration: 10
            arrivalRate: 1
      scenarios:
        - flow:
            - get:
                url: "/headers"
            - post:
                url: "/response-headers"
    EOS

    assert_match "All VUs finished", shell_output("#{bin}/artillery run #{testpath}/config.yml")
  end
end