class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://ghfast.top/https://github.com/grafana/gcx/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "0692bf03944dac8fc70aac183fea0243a9138bc00491f590f0d209a8de314fd8"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd358d9798ffbb7b5d2381b2fddd52095f68ed148041d0d679f3f9013f54e1e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8842082740e99ec9a7367f1069363ae6f2b5eef79f4c332a9fc99ae2c33e1f61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f042e1013bec3495c996667a5d8422151bb0c8e60a1607db4b534ea25d951f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9bd9eaba8ae8b5ad4daee9cf17c548c37a492f31f53b3b165baa6436bced9803"
    sha256 cellar: :any_skip_relocation, sonoma:            "ef98e4388b1d73c1ec81ba1c1f3be2895ba8a6eec6e2f491d81024ec228d8c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82dbf9ba4c4bf07d585ad9b9f39b236a096c891a17867b5771e7179804fdc5df"
    sha256 cellar: :any,                 x86_64_linux:      "1001f6928bdabe01347e772dc829a1bdb98ba875ab6ff1fb9c85c2597009096c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/gcx"

    generate_completions_from_executable(bin/"gcx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcx --version")

    system bin/"gcx", "config", "set", "stacks.test.grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "Unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end