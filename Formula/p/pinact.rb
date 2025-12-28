class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "8667ae4815c1fad1a9bb775537f45b6cbfec90d7077c47d60bd67e1b07c8b90f"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da3c6356bd2508840e39203152b74673e0ec72b0853a669c853fe4b9f7784e8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da3c6356bd2508840e39203152b74673e0ec72b0853a669c853fe4b9f7784e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da3c6356bd2508840e39203152b74673e0ec72b0853a669c853fe4b9f7784e8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6828cdabb12180ac09462f5bbbd3da3ba767103a008dc6f4f3b7c8fdac28a303"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7c198d1cd7919efaa52d3cc51d702c60bc9828af972a744331d686154cc6e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf797794d40b8f3d737a90d3c32861f54314649a3aacc664a816b2bb7cea6f86"
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