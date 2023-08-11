require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-35.tgz"
  sha256 "655d789d87b53318f63e43be1cd4b88e79a70f868a034d78a01f1ae772585171"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "1c75a603e4a4a40aabd8cab302bc1d0bc579c1baa5f1a3a070396aa4ff97a066"
    sha256                               arm64_monterey: "878263fcb95d39082ee555a7d3f7ef7a89be6c38a8998d6ff595872da2c26253"
    sha256                               arm64_big_sur:  "56311c6260756afdf24ee225ff4c91e9a837d13d85afae8fc7acf880b80437ed"
    sha256                               ventura:        "61e697ead334014f73fa6e195bfbbf5786b5aa1c671c06ff84ea5a7c66c0dcc3"
    sha256                               monterey:       "15c2bed028c790369ca2f8692788c1e64ca75a72a49903b56882981c724dfaf7"
    sha256                               big_sur:        "68a6fe1583f09585704073e57e98b9b8a85399b01dbbe4e27e97f2c8e5a3eb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7954fad63e42b798c10e9d05bfe96120de3445c74e72556dd0ee461317aec9e"
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