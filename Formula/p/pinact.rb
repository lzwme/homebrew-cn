class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "0df5b888045092abcef4d12ef043d63eaaa12c7254f843441443b8c12fc805ce"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae59f2ed6b51a77884df8176110af3493651e559469aaf90c94ecbe177e4301c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae59f2ed6b51a77884df8176110af3493651e559469aaf90c94ecbe177e4301c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae59f2ed6b51a77884df8176110af3493651e559469aaf90c94ecbe177e4301c"
    sha256 cellar: :any_skip_relocation, sonoma:        "55219d3abdd43254f845c58301a931ce42667318b3aeed798ebac982dade851f"
    sha256 cellar: :any_skip_relocation, ventura:       "55219d3abdd43254f845c58301a931ce42667318b3aeed798ebac982dade851f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c2cde1a9ddf924c0a8009c8628d71d46da4e212a4b42c784179df4eee2535d8"
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