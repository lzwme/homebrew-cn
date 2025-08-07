class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.7.4",
      revision: "0879931d11d5e6f3b62adffef5169196c1be107a"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da53e7c2205fe2b3b01c2cab5dc7d34025d11d66e32e82c0f3280f4e35536530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da53e7c2205fe2b3b01c2cab5dc7d34025d11d66e32e82c0f3280f4e35536530"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da53e7c2205fe2b3b01c2cab5dc7d34025d11d66e32e82c0f3280f4e35536530"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b244be57c24fe24452ea2c13b1571d8f182eb6f42a79202ebba0ed488430eb"
    sha256 cellar: :any_skip_relocation, ventura:       "41b244be57c24fe24452ea2c13b1571d8f182eb6f42a79202ebba0ed488430eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99e920a293f8c6476d604b454b5b902e2a42701df6f96ee11034f67fc7d6d83"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end