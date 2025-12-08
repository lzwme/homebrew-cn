class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.4.6.tar.gz"
  sha256 "c41d0a606a2a3e6e2e963d5ccae61495084fc28acf30a292b6608e14333fd760"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4030d9d433419ef5fbaaaf704db3962575d8000c5fb0573cdb3c2c446e6ef796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4030d9d433419ef5fbaaaf704db3962575d8000c5fb0573cdb3c2c446e6ef796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4030d9d433419ef5fbaaaf704db3962575d8000c5fb0573cdb3c2c446e6ef796"
    sha256 cellar: :any_skip_relocation, sonoma:        "14c2ea83fffd0ea9350d19dfc664bd502fea66b33cdfbdae73ec4d8ba1841b41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "541c749f85c000a1a1025eb4d83ecb01d582efab661cb6bc46a26f9dd1b14b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9a83e6e6c74addb67b8a7e8a2fd25fe7b572cf016f542461579e37cd0f0497"
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