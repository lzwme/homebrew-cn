class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "f4b34a86afd43d0ddd7df833e7755e131dd06cdbb057d549a52a707a7eee9184"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f939c7608dce540c3a6e0e2b32e91fbf6636799bd3361c0462a662ace9a23bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f939c7608dce540c3a6e0e2b32e91fbf6636799bd3361c0462a662ace9a23bc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f939c7608dce540c3a6e0e2b32e91fbf6636799bd3361c0462a662ace9a23bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e495083a60f338860ffebbe9cefef3d7066507a63d50918ceb19399c31248df6"
    sha256 cellar: :any_skip_relocation, ventura:       "e495083a60f338860ffebbe9cefef3d7066507a63d50918ceb19399c31248df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150c02c37e7041318f6e209dde3b6c77ef6c6e989c8ddcaabc732b8bcd23cbd6"
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