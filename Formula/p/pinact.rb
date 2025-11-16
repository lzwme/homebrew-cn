class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "c50e43253389d41f10b44bdf7d8c1cff93734c1b9a4d158b6350fecae039514f"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd6a0bdfc12cc53c96fc5d387b1bb3a2041c730ef7923177b0da5f4a13ff2195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd6a0bdfc12cc53c96fc5d387b1bb3a2041c730ef7923177b0da5f4a13ff2195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd6a0bdfc12cc53c96fc5d387b1bb3a2041c730ef7923177b0da5f4a13ff2195"
    sha256 cellar: :any_skip_relocation, sonoma:        "833fc1899c102c01c4dc551f0b6780ce82589f016866ffa580b971035d47fa6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccb73bef67ac316c1f4f0a40bfcef7bd2068a4757c665aac89c835a647612d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f26f950c7609d69c7cdf892c54eebfdab3295d25a3d9f5abaf9eb60618986cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end