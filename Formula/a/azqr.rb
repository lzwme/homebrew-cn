class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.0.1",
      revision: "ffda262cbccc33bf4f472c07f81758839b165b1a"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fbe65add3e6c2b5be38f03fc441fbf8137f1b71e184b93aec538d2be8009950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fbe65add3e6c2b5be38f03fc441fbf8137f1b71e184b93aec538d2be8009950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fbe65add3e6c2b5be38f03fc441fbf8137f1b71e184b93aec538d2be8009950"
    sha256 cellar: :any_skip_relocation, sonoma:        "14069091723514b725a38a12762e9e9786d09b2fb7424bf45f8b2899087460b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f199bd173534d0dc07c71af6283b3b86b53de7bcd075286164eebe3d4f6f5129"
    sha256 cellar: :any,                 x86_64_linux:  "bcb747d0c874f7e6a903c7067b9835d04a27282ae62c34b5081a429260b37776"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}]
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