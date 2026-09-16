class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "18f4e2aa9c0f0f97c08c2b0d18b708ca818b7ce0866d73aeea911586b2f86fb1"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e00478e9a98cee06279f6595e3baf36eddcf9a17279af80212673e5ce61c8787"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "987bc5ef667b9aef72a2b86f723719dd5e2fbcc5d23820428d92d92dd11eb226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "529b0116b4f96d1ab64180e2ec516ae206188d816bbcc35f7ea74340a4cc9b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63c981f67998466bb088050e8384b2945b8a191e3e7a2dcf98eaf343b3e1e46e"
    sha256 cellar: :any,                 x86_64_linux:      "58333524e57340abdd35b99829b176d6a85695eb702a5c8b94e0eae78ced346e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/owenthereal/upterm/internal/version.Version=#{version}
      -X github.com/owenthereal/upterm/internal/version.Date=#{time.iso8601}
    ]

    %w[upterm uptermd].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags:), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upterm version")
    assert_match version.to_s, shell_output("#{bin}/uptermd version")

    output = shell_output("#{bin}/upterm config view")
    assert_match "# Upterm Configuration File", output
    assert_match "server: ssh://uptermd.upterm.dev:22", output
  end
end