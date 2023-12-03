require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.2.tgz"
  sha256 "e03f18951762f3ac0e5325fea657d0ebe57deae921ad5e5ff9cbf485f35a1b46"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "6069dc4e38314cbe04fabd4fa5f99774cbfedfe9f7dd6cefc3f10287fc7b8a2d"
    sha256                               arm64_ventura:  "665c3dcf22042e1cca8b02c063644b4f18f5d2a950793f472713fb654614a61e"
    sha256                               arm64_monterey: "4f8e4656fd357f776676f00f2c175b7313b513a0bb15fb5df4bf83df3e35cf96"
    sha256                               sonoma:         "f3719c8e105ce8a473053e601707bb8f3dd873e4690e1f6d7d1cdb2a4e3089fe"
    sha256                               ventura:        "e11af076d29dae19bba2be4a90fb0d3e95cd74baab0bfe489ccc844a632a3af9"
    sha256                               monterey:       "e533d83e780e840ad3a02061e0cb34ecb848a88c97ca02f1029b8dd16345d120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e3367db3165f9d0529f54223bbdb77dd2dd54c194f2c41d84ef74c1495cdc3"
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