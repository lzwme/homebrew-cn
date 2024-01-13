require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.4.tgz"
  sha256 "35d3f4f2c6c1444fae9a6ffab62807f2b832689fa738c77f3f0a7e3dc370421a"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "402ba9c375174d9a8d94fc3bf5fd0ba302b23224a76bcee6589f42ef1cc06538"
    sha256                               arm64_ventura:  "c7eee6aa9f4fb3bfd50b6dd745b29706187ad772a2675b6385ec0f543d82db45"
    sha256                               arm64_monterey: "f7591819276d1fb0213824f62e5da10db404acb7bc1d52b2027ab7dcae122954"
    sha256                               sonoma:         "026112f44ed2b894db8b98503b3176cf48e07268f616a087970b86da11a6e52a"
    sha256                               ventura:        "1380899442c0bc2d0febb15fdb06c8e017f027546fdad7682bbea4b74cb20936"
    sha256                               monterey:       "576bd67a7458029844b316a3dc4f47c1145fc3ed482031fcc995447bb380a77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d31ab61f8658019fa17e41afb7f38b99501113ab165d6cdef6ce259b4760c3c"
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