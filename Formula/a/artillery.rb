require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.17.tgz"
  sha256 "e5ade820f06e8979bb04552d8fd264738c4a4d0b5c22e6af469ee632d01d78dd"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "fd12d00e51d0841426bf3de24a0b579eda33ef84abc7205ffb476a4f7dcdd5c8"
    sha256                               arm64_ventura:  "2c0f78e14f2927e45b1d96faa7b727587297b0410c7c56fa867bf2e170992ab3"
    sha256                               arm64_monterey: "c5db42976a0dffcd4a6a6db541622677e337b0e5ddf21bb2930b1b6c76b35aa2"
    sha256                               sonoma:         "f37d16c4e1b2e98b86a9b9a83803f16546d003065326d34f21a7f93fd271f264"
    sha256                               ventura:        "c43b73b34095b734a60194d6f7b2f5837b1de265ee8c632e4bb4a1a5cf2e2d9d"
    sha256                               monterey:       "bf02f03cd6a7460234513504580d196914c32d3f7eb0517d423da35ac4a5ec1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "308cf72de824e58bed4a8ede0c99895cddba99c3dfd8ff5d91d731c62735199e"
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