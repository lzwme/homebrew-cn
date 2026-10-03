class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "ae12c8baccce87a6f281662659a511e6430747c28629a61ac4a2895e0bfaed52"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be9e15f5d0847bea2452dff69a25ffa555628abfaa928fe4d1f91c69a6eb8df8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df3460845fded409badf43633de170d63c7c286b4ca0182e1fe032c7f6a43b63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "856e9a5eb716b4b97c3ef05c64aa30f74e2e0a99d1ab6c3b6fe735e8ad59b3c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f65c6f6e1fca2fa4a4af43aa69171171a3c906da0c2c7b61e1af71e5b2e6a4e"
    sha256 cellar: :any,                 x86_64_linux:      "f4197cd44eece3b942ae9aab68dd394b2ec6bc8f370ae7bbf847bdbdb3384b3b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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