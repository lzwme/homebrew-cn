class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv1.6.0.tar.gz"
  sha256 "70dab074f1012bd4922ab1550ff2780100174be0c550c9ffcfe54ed6c5b81f76"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccaa534b8635f703719659b512d5eaef9637a66f32a0ff1d385661634596ad4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccaa534b8635f703719659b512d5eaef9637a66f32a0ff1d385661634596ad4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccaa534b8635f703719659b512d5eaef9637a66f32a0ff1d385661634596ad4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb6c83697db5af43d83fc611f9431516db34bc7dba9ce0ddaee01a4a01283f8c"
    sha256 cellar: :any_skip_relocation, ventura:       "eb6c83697db5af43d83fc611f9431516db34bc7dba9ce0ddaee01a4a01283f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb578a94a97fd4313210b7489197b92457dcfc9edb82eae185eecc275a8f272a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdpinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pinact --version")

    (testpath"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actionscheckout@v3
            - run: npm install && npm test
    YAML

    system bin"pinact", "run", "action.yml"

    assert_match(%r{.*?actionscheckout@[a-f0-9]{40}}, (testpath"action.yml").read)
  end
end