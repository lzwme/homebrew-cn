require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.14.tgz"
  sha256 "fd006e6023268afea2ea89756a996f8ad7643e4b4c1c318e64426b95e06cc72e"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "fb6167c3edb3fd06f9d17107efc81768868fc33047cb41c71c9367b8c04bd7e8"
    sha256                               arm64_ventura:  "2e099789abe4c1c369b2ca0b7de432fddfb9a2ee7980d4df82c93fdc3daea768"
    sha256                               arm64_monterey: "6f199ec8bd7dcf0c70854d3d69ff8f3022cd4a5c71b725260d73b4c1f0bf711b"
    sha256                               sonoma:         "10c7072ddf3171a26a8b43a20755e1746ea5335fe92059b9581d7115a44a0b8e"
    sha256                               ventura:        "ee107b8247672ed5d286ab07d2185c87791d91ddd1923863d30161f4637f7a0a"
    sha256                               monterey:       "dbf274365a7b5cea1f363d91ee7277591fea04aae12ad5df0ae03bbe03887214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3d2c8cea815c26558bf49bb41253896ba5b2c016372e97174f64f740c44d755"
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