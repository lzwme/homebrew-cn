class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "c85d427063ccb5fc5fa7e676c104c5bdc64c56a6f03ccbe7ef8d46ccd05d6827"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46634aa5765d096ec89eb42def80b04a186c71b033411698f41b2ab732e90eb1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67f9f384c3b233008d2eb02a90ea4887ab971027218b94c7658aaad898753cae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "722ad813e354eeefd0797b7d84050bce2c875deff68bfeb671fba064972d681b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd94ee266c154c334b6acc5c372307fca20d4997b7bff5687943619151206620"
    sha256 cellar: :any,                 x86_64_linux:      "77160ab02bab8037b34db418e77e79f0b891a576513f420d618a7e6ddf69ff49"
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