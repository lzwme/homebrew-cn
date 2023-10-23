require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-38.tgz"
  sha256 "4b110c4eff35e3a786a88429beb05b9fd0f50eb22c045e687d10d9ea886dc86b"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "4fc24d42f2c84758e528981df38c70551ae965c4227a5b625e003c4b5d8026b8"
    sha256                               arm64_ventura:  "ae4e4e3a27c311a25865ec6f64af64c20d4fee22eb46f734a3250b5ed6b2bf1c"
    sha256                               arm64_monterey: "6de5619f5cf0fb9afcf80abf1301d7628ebab41e1b0f2a5df64275ebf7e83517"
    sha256                               sonoma:         "bdae67900a63c770a0bab56b122252016991ac9ea1904c99c8f42f30cfbe45c5"
    sha256                               ventura:        "f29faa4a5bc2d92e447f31c05fe0bad648b8557eaefadaaa6f709bafb1cf243b"
    sha256                               monterey:       "85e8a1484e4f42f81a40e3758f287ddff0b1470b7c0c2a3e01c7a6da124732b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9005ee5d17851fa0260a4958e69312daccb03d6d301995a0aa0d17b4b9a2af3d"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/artillery/node_modules/fsevents/fsevents.node"
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