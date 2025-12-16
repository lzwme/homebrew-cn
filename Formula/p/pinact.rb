class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "dd024b6cac128bcfc71c5f3c37261575e0b3ecb0a5cfa15c432f0edf1b70d1e7"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5314d3c72376c012af342ad891971dbe0230b5d98e3bb04cd5912c0ae25d1bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5314d3c72376c012af342ad891971dbe0230b5d98e3bb04cd5912c0ae25d1bf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5314d3c72376c012af342ad891971dbe0230b5d98e3bb04cd5912c0ae25d1bf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1a28cc0e2d2fbefa74255904be007e23e2cf6081f9672a774a4fc7dd71de719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3f220275ebfa402198c7cbf0743c680d63f1b9d332fca153120a9838bab93b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "886dcaa482c98a44dd5866dcf8fa52be02667ccd282e9ff7fba35234db131e24"
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