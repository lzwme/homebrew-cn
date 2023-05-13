require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-32.tgz"
  sha256 "5c5b193bb42373861b0fd10228a4a129ccfe87f061668198227a876fb6c633b3"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "c235bca75d0843f5092c2db40ef200d0338998c9b83c4cc9e431b90f38c2b940"
    sha256                               arm64_monterey: "8d6fbc60da0629f7cf113fdeb5642ed0390ced4377c64a229d7bbf0458dbf113"
    sha256                               arm64_big_sur:  "72eec3cac37c9efcf8f687457b8071fd9f6a791ddd1d52f0a98cff74e547dd74"
    sha256                               ventura:        "015893149094d9a425410764a813bd31cbab28e1c8707da57f120375df558a03"
    sha256                               monterey:       "f43230dbc6c9b7b7a786b1eac637a509f33e4e3e924af69bc83edd595d7f2cad"
    sha256                               big_sur:        "f7128a04075d2c3e5790f4d2cbf67448775efa8e724db74bafa33d747e4143ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b783387f7b3d56fb209dc163110abb52bcf5484a3d7510dc7309a3c933c9fba"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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