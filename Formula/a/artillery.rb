require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.1.tgz"
  sha256 "30b20970234b10152c9287d66456f54a35df1a58fe8742d370f16e24c8c2036e"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "b19b2be8c7667a240dadad78146311d3fd0b0ba21bf25fecb3b2422e0b1b6234"
    sha256                               arm64_ventura:  "501e7f0114c59a4a40f412f70be9bd7b9de7a413f697fbe6d129eb156d7cf231"
    sha256                               arm64_monterey: "c934bc192ebe522d28bede501038d8da30a0792c35a24f34fb0774a75f8f8f4d"
    sha256                               sonoma:         "d8121d96a6e50383c84d3ac0296bfa1c40c3821dcef36bf766136eaad22d87a9"
    sha256                               ventura:        "47e5c4f3b513ae3517777428000f1a2d70a037a1c960830084c05025e2d364ff"
    sha256                               monterey:       "6217c0f22b8079aea6d016752474cd995a1acfb594a48549a14de817d401ab9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3b57b5e76f82534d75482a08659a674a5943cee4f7b8a500bc1ee3facb42d1e"
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