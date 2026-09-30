class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghfast.top/https://github.com/openziti/zrok/releases/download/v2.0.6/source-v2.0.6.tar.gz"
  sha256 "0e4a7d182e2bde3678bd2f3f92377eedb0c7b05324fb977d8e98c2ef089f56fa"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86b9f0214939b0d26c2c9701d19efcbd452bbe56fbc28cbe4473e5ce73bebfaa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3110f8393b8d3a68f6d4b9c942699d446c50f4ac76b12dfe903df54b03c7e0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd2b32c48c45557980eff5a20cffea508f1f66160fe727ffa501696751357532"
    sha256 cellar: :any,                 arm64_linux:       "e1d79cf91344bfc9496188df497ef93f1aef2a5bf649604f759f2df2e8fa53c2"
    sha256 cellar: :any,                 x86_64_linux:      "4aba7edbf72d040a2ff1f349ef370db8aa47e765f03e7504fc06bb457a730cad"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def ui_dirs = ["ui", "agent/agentUi"]

  def fetch
    ui_dirs.each do |ui_dir|
      cd ui_dir do
        system "npm", "install", *std_npm_args(prefix: false)
      end
    end
    system "go", "mod", "download"
  end

  def install
    ui_dirs.each do |ui_dir|
      cd ui_dir do
        system "npm", "run", "build"
      end
    end

    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -X github.com/openziti/zrok/v2/build.Version=v#{version}
      -X github.com/openziti/zrok/v2/build.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zrok2"

    generate_completions_from_executable(bin/"zrok", shell_parameter_format: :cobra)
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
    assert_match(/expiration_timeout\s+:\s+24h0m0s/, status_output)
  end
end