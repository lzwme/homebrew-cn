class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "37253e5545c5e27b04389df10bcc9b863dbe236117788e9841e416296b41036d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f717d6f8118a927598c767ec09c11ed8f7f73c45f6d92d77f8e5162f8c82108"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f717d6f8118a927598c767ec09c11ed8f7f73c45f6d92d77f8e5162f8c82108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f717d6f8118a927598c767ec09c11ed8f7f73c45f6d92d77f8e5162f8c82108"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4fe908869c1c7b957d9ee98080343bf7eec24ecb424a5ff45b03219f786d584"
    sha256 cellar: :any,                 x86_64_linux:      "8da4bc1c70173723e2ec66c32fa3f0c41dd29d32fe435b1e0de028c2c1ddf239"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pinact"
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