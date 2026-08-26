class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://ghfast.top/https://github.com/openshift/backplane-cli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "f07831763f7d0beb4f3522f5af8646a24abc61c392c7f354a5230c4a65637aec"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34e05d3b27748a51f42b1e26cc3a3474bc97b223f6010c4d5b41cc8d8bf8a119"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6da47b16082bcfdc77961c32186b6daa977f163d71adf9aa1d522ca35ba41ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1829553d8ff651a9b4c74d42be16d104d58add147e7ff41aebd111a73016fb33"
    sha256 cellar: :any_skip_relocation, sonoma:        "c495cc4ab998b027379a032299c5ffaea46d620636d52e7838897c6a10fda4c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1550b8bd1e99ecf799f38cde96d4082869198763d9120276e612b963ea791916"
    sha256 cellar: :any,                 x86_64_linux:  "911261ee8d3bd2e1d9e5815d86a45271dde161780e21757963a1dad8ffda2579"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/openshift/backplane-cli/pkg/info.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocm-backplane"), "./cmd/ocm-backplane"
    generate_completions_from_executable(bin/"ocm-backplane", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm-backplane version")

    # Verify config set persists to disk
    ENV["BACKPLANE_CONFIG"] = testpath/"config.json"
    system bin/"ocm-backplane", "config", "set", "url", "https://test.example.com"
    config_json = JSON.parse(File.read(testpath/"config.json"))
    assert_equal "https://test.example.com", config_json["url"]
  end
end