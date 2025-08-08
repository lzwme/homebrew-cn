class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghfast.top/https://github.com/openziti/zrok/releases/download/v1.1.0/source-v1.1.0.tar.gz"
  sha256 "926e990d4efce805e19e03af21c31165a0262cbfe7ac9e3a2c123f4dde921364"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d493895ff59f650d4f611ee91b1d3cfff54db161452cbff3381b186a40f4b3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f3914f383601e99a6221e2eb52e40959d970cc3f55e6d43e9983d1e21c11e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e97a44048a93a4ab874263b363c27ed12bf249bc7ea11c981103e7caeddf3aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "c817ff60eaa177dbd9df423a6342ec2b29dbd6df02ba73ef4d291453f54b5b1b"
    sha256 cellar: :any_skip_relocation, ventura:       "2c8c5da6e9a92a8080360b8a33dac736a72a169f7cf246ecaae914a7001597d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "884962db14239ce14b5dd31091a0ed3ae77800d84d878d2f53a111a10130ba64"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ["ui", "agent/agentUi"].each do |ui_dir|
      cd "#{buildpath}/#{ui_dir}" do
        system "npm", "install", *std_npm_args(prefix: false)
        system "npm", "run", "build"
      end
    end

    ldflags = %W[
      -s -w
      -X github.com/openziti/zrok/build.Version=v#{version}
      -X github.com/openziti/zrok/build.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~YAML
      v: 4
      maintenance:
        registration:
          expiration_timeout:           24h
          check_frequency:              1h
          batch_limit:                  500
        reset_password:
          expiration_timeout:           15m
          check_frequency:              15m
          batch_limit:                  500
    YAML

    version_output = shell_output("#{bin}/zrok version")
    assert_match(/\bv#{version}\b/, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end