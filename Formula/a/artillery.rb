require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.13.tgz"
  sha256 "cf3a11032d37c0c38747cf851efd661088da82b2c3641a4776f34c73ce269955"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "b5813c115ff1090343886ff029e5ce52f013f779f78edffea5bcb3ac4bf0ce49"
    sha256                               arm64_ventura:  "025973e7adf634bf76c530a227d2432b3fdc68dea35de7427ff358432152de4b"
    sha256                               arm64_monterey: "d10842fc34605a65ed58deb4f00af7ff8cfe2b0bfca5f6e492efe33116327d9c"
    sha256                               sonoma:         "00502a9ea197c7ae01291dc6c547d76ef5853aa4007ff4935f7773800789caf5"
    sha256                               ventura:        "f922122f796b9a48c595306141c3573557d4a604255cfbf312dbbc166114a272"
    sha256                               monterey:       "1fa76845c3f81ed3c0140ffbf24600de7719aede40651d11baa050260ac6da4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f121dedd4a6ccdcbc8655fa655e22524769b5dd9843c7cf115e7de179be2fbe3"
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