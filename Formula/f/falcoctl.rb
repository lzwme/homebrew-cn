class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://ghfast.top/https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "49a0e64c05444be12ec75507c069292d26c9057ed5353ea5d10f1e9b7d7ce0df"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff60342e6b2dbf27d260811f77833123facb7fd54d22ec41a18732c7a5624536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51f661ee4f301a3eb77909471a4c29eb9f204792691fca6e69bba261b6b03e58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a1a4c8dcd7c0a84f52803c5ec253ffa72c23671955edd38f5e517636dd65c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f157aa98e15ece0b1fbe997036db6745c93827f21a63c3ab6cf8bf7b23d3f4a8"
    sha256 cellar: :any,                 x86_64_linux:  "37116db3eb7812c8628abffc938031a910d7b13392124d21754cfa11ebed2926"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"falcoctl", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"index.yaml").write <<~YAML
      - name: test-artifact
        type: rulesfile
        registry: ghcr.io
        repository: falcosecurity/rules/falco-rules
    YAML

    config = testpath/"falcoctl.yaml"
    system bin/"falcoctl", "index", "add", "myindex", "file://#{testpath}/index.yaml", "--config", config
    assert_match "myindex", shell_output("#{bin}/falcoctl index list --config #{config}")

    assert_match version.to_s, shell_output("#{bin}/falcoctl version")
  end
end