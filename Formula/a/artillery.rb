class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.29.tgz"
  sha256 "62fd4c07a707d15e715b3ba01d0a73a5920a84062345019e8d771cbc04ad165f"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "5693986ddbe94e6c56348073f5ad1dff319c75abbd3b7c9dfd565cd575ee2d45"
    sha256                               arm64_sequoia: "6e379a6adf5ef2870f603ee26f5546521da54ce0c78f72f11d6bc10fe001ab1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62542bcdf74ce36e2bcff048c51a35e9ce33fc021ceb207a7e67129f37ffe205"
    sha256 cellar: :any_skip_relocation, sonoma:        "62542bcdf74ce36e2bcff048c51a35e9ce33fc021ceb207a7e67129f37ffe205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5b1475ad5f913acf850cfa46f19f3f3354c20ce59147ba8e80ee2d99f88137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ae3740518e98a601885883705afe176f481a21b0e274638a73f4fe3551cb2f"
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