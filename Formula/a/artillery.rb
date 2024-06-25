require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.16.tgz"
  sha256 "72f0a777c9cd206ab72c75d3f8f4579ce987e839128fed3f83b2b142e5985eac"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "788f7d6043879016c3ca70d706fa3a427ca923559feb63643458e67a14c65f64"
    sha256                               arm64_ventura:  "0c4aaed820d67013421c4635b96fccf235f69561ad7957d831982850d49c6546"
    sha256                               arm64_monterey: "081231b95808aed1f09a2baf136c706fb59703ad0525f1d00706d2361d671c03"
    sha256                               sonoma:         "3c0013488b655fd517586347541f15c8d2c5f611e069a04dd2073c576f26fd76"
    sha256                               ventura:        "4b4b2cbfba8914ba1c82e60133cb4b3132fc520d8bbfe61c8056ba43b4877360"
    sha256                               monterey:       "a280767b9422afc9213bec89ecf45b5c2758c93bad44c3c1b7817f8cf3fb8612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bf429c1a47a63aa69d69ec9c0716e7c829916c45288760b8e705180dfebad3f"
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