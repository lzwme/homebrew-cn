class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://ghfast.top/https://github.com/Boeing/config-file-validator/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "b5f80b79e1081190d6f2f2dae8f13bdd59157a3456b7617cf9d90e86f3afd101"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d4caeb8efa01a5c2831d8091a44b1529a66f401b5855c082314f6119952685e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d4caeb8efa01a5c2831d8091a44b1529a66f401b5855c082314f6119952685e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d4caeb8efa01a5c2831d8091a44b1529a66f401b5855c082314f6119952685e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b039663d09b34c9a55df85a8945ac601c2766d1f82183a9deab026b823607bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5c7d6503d6951be95f27ce663afa9dbfba0e87af6c825d195d5c59d672dbc30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace309d0ba0e2735435a3b42974c3990205a79e28e14452d4fa349e876a65055"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Boeing/config-file-validator.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"validator"), "./cmd/validator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/validator -version")

    test_file = testpath/"test.json"
    test_file.write('{"valid": "json"}')
    assert_match "✓ #{test_file}", shell_output("#{bin}/validator #{test_file}")
  end
end