require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.12.tgz"
  sha256 "ae8fb7812dd6adc27624be41c015d02cc599077dbcf0bad46179fd2380ca6a0c"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "e7d13df3d35a7f1f6988eae5e8da098d2d3764635d3908527c442eda89421713"
    sha256                               arm64_ventura:  "08fa01791555efec61d9a5ae613c5cf0408e1054835d35f2fee87accca6f84af"
    sha256                               arm64_monterey: "b79fc87686309cc5256e45a21e70b3168c0f72a90ef13830992573c26e4b0808"
    sha256                               sonoma:         "359ac42a1fc006a6b5d5aad797297635309a0186e568423e257c55374721c443"
    sha256                               ventura:        "62e53eb9715058752339bca26309bdd026fcf0310ada4614d6437b0d2346b8ad"
    sha256                               monterey:       "157f9ed683a9089511786fdea580a316a59bc3f1db43bedc5f4942dde44ccc26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3511eed7d668156fb08b7101727e24b6044a0d0f14f8bacbba4d8969052f0172"
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