class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.7.4.tar.gz"
  sha256 "1b8fb25aac4ac3cf18db639bd0c013bdfb7fa3f17f92429fc0c5df592a23f632"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a340c19a6457c9c70b8264ea4068c045ec31513c9400b780be28587fd0ea19ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a340c19a6457c9c70b8264ea4068c045ec31513c9400b780be28587fd0ea19ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a340c19a6457c9c70b8264ea4068c045ec31513c9400b780be28587fd0ea19ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9850309acb96c2f7b303fb2274763306ae0b73cb195e4ed5a4a395c58ffefd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d34bc6a22dd778bfc60b817635248faaea8799d77f16c0ac0fa29194f17c04fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2a9863585f3affc6a9c5fc1c62a46066ad0996c509e3762fad5173bc6a1bc2c"
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