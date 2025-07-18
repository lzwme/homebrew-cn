class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "eadc0fd9ae415f984f55f1fbe266fa7e3578138cb7e2182e26f4288e261b6235"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0abcbe45e6c1bd13225662c73fdc9423f7b4fe4ee6742c78c61cfa0c756a0902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0abcbe45e6c1bd13225662c73fdc9423f7b4fe4ee6742c78c61cfa0c756a0902"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0abcbe45e6c1bd13225662c73fdc9423f7b4fe4ee6742c78c61cfa0c756a0902"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a1cefdbb67d80b193d173a5badba087f1664ada06f85c36db55971260b111e8"
    sha256 cellar: :any_skip_relocation, ventura:       "5a1cefdbb67d80b193d173a5badba087f1664ada06f85c36db55971260b111e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc179d57e25129cccfd534b576faee94ffa83724f274ea5f7219ebbc309c749"
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