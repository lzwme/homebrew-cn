class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.2.1",
      revision: "8d03fa7a536e98e87de3044c1a0f8240b129d16b"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29b4e990f67a92e2767134e77ee5b45c65787f2e6babdede17dc604682015f60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29b4e990f67a92e2767134e77ee5b45c65787f2e6babdede17dc604682015f60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29b4e990f67a92e2767134e77ee5b45c65787f2e6babdede17dc604682015f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c91050acc700ffea80720f91d2643be73e26ccdd837239737fc62057737634cb"
    sha256 cellar: :any,                 x86_64_linux:      "413007b22f98993149e46c0d9ac47f4f0ab1b0260029c00c4f23e31a688728c7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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