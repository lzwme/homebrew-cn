class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://ghfast.top/https://github.com/open-policy-agent/regal/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "0b5244f8cf7fa30ffbbc8c002c7b3999cb1d0e1edcf2de8fb1f244784c7eb86f"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8059f850edfc73948843c402a5e31701ea1c96792c6b90fb8054a5939500ec9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eab349ca9e0533521ac71aa86ea05b9d64ce9eb03198420e84c84d139cec9aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d374e699cc63ce85ee3a3e6944e0b6f0ae99ce691e03fd6546f537c937bb079c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a72f710c72afbc2af9207c167c2b40506cf350cccedd985631092f489b78fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e259d7ec3fcad40b6a77d9a23c372691042915ca150a9a6022e1f9288f94a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af0ab687b45ed7a94c26186390fd7bdb5b6ba53f2436211b10d1eb9bdc36f4c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/regal/pkg/version.Version=#{version}
      -X github.com/open-policy-agent/regal/pkg/version.Commit=#{tap.user}
      -X github.com/open-policy-agent/regal/pkg/version.Timestamp=#{time.iso8601}
      -X github.com/open-policy-agent/regal/pkg/version.Hostname=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"regal", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test").mkdir

    (testpath/"test/example.rego").write <<~REGO
      package test

      import rego.v1

      default allow := false
    REGO

    output = shell_output("#{bin}/regal lint test/example.rego 2>&1")
    assert_equal "1 file linted. No violations found.", output.chomp

    assert_match version.to_s, shell_output("#{bin}/regal version")
  end
end