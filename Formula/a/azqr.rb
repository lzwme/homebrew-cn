class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.16.1",
      revision: "3638210336c32774edbec56626d8587dec982316"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4f2e53c7230c7c07d0d86578a47971ba86a6913ee6aa09ebdad9f343eac67ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4f2e53c7230c7c07d0d86578a47971ba86a6913ee6aa09ebdad9f343eac67ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4f2e53c7230c7c07d0d86578a47971ba86a6913ee6aa09ebdad9f343eac67ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd7486a34d1f49999dc31983ff7b79f67799637489d1669e05c170bc4a54aaba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7748e963cc22531377e8725e024b901856217bf11ced8f3ea4556887dd642eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7cd73b959d22ef3e582bbe7a3fb27ac0c2b5b78c20c7f705d27f226ac483d2d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end