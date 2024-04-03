require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.9.tgz"
  sha256 "f776e53df01779f42377f51d3f11f9075a90172a08dcc6263db5a71ad929854a"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "56abbc1b49ea125e9c0638fc27d0876b3254b5e4f98dd89e64e1058ace1f4ca3"
    sha256                               arm64_ventura:  "1184632760e9ea5589d0c1bd369a7bc1a9b1149a786a19c0333c913722042696"
    sha256                               arm64_monterey: "7ca5f61fa6851b9ba97e5e94a5301124f4de9648bb50fae9a1df67db67db93c6"
    sha256                               sonoma:         "fb834468344a4e9d732909880246a97e0e2e5b994fb560e1a15ae58f5075314e"
    sha256                               ventura:        "877ca4780e941c4023a5fa6cb355321f50bdbbe5f7a47e6847f49ec35f983dbe"
    sha256                               monterey:       "571cd87ced10a38ce21ffd06c9a93e2f2ed731a0b32291c6874bcfa6f00f3e35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea4e4c969233d7f0b9fdee7fe59ebc5a0fd51d4210d858173fed8908f9c77c3"
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