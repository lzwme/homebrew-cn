class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.28.tgz"
  sha256 "e6c076be5d049caaa5071575e93bf2870df5dd58228c14a621d1e5913983d445"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "d749c55701f440e9cd4055b1abc8f8f332470aaa82c48a1a5c04df16c5d02dc5"
    sha256                               arm64_sequoia: "78e9a651f47e9ed9bca6b367babf671cceb90e960a99934a8a7577482800283d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e285eb18b6cbb5ea40e4f6b3562c3592e4fe765931075c1d8c965de4f73a69a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e285eb18b6cbb5ea40e4f6b3562c3592e4fe765931075c1d8c965de4f73a69a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ae23d0f6ab288af185259363fe4d3e0603732a2d4a35d8088e841346f22b2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd998e7f008e7c741f92bd03da7f69a39d8a28ce7d64230124b6fb42295c767c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"artillery", "dino", "-m", "let's run some tests!"

    (testpath/"config.yml").write <<~YAML
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
    YAML

    assert_match "All VUs finished", shell_output("#{bin}/artillery run #{testpath}/config.yml")
  end
end