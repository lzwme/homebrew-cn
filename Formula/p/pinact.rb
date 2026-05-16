class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "e2661031b43e5980af34ca323ed10f72112c056fc0c495424dcccdd85ab6db2f"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f54eb2d58bdcedb5211d82ca816615767841cb1d252872cdd9f3c330e14265bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f54eb2d58bdcedb5211d82ca816615767841cb1d252872cdd9f3c330e14265bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f54eb2d58bdcedb5211d82ca816615767841cb1d252872cdd9f3c330e14265bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ae182673d239900ebb6dcf142c34cc47d499ca4186bf914302fb72512afaf71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b84d50155e387be0b82c939a4b203cb22dc08220baa1dff26bd97cffb9150f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f93b2e8aacd06f75850d707895a1f02bc91be733c7072618593e50a0094dbefc"
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