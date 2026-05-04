class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://github.com/owenthereal/upterm"
  url "https://ghfast.top/https://github.com/owenthereal/upterm/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "e990c3c00ad378d32bb7b42c8131fe0c310b342f926d860a682e36a7d0cabd78"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bf23d62d534c91711ce71ca93bf8af43590572fd4a45ff755d553048151960c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e129ac180740683b6d39c4691b001705ceb88527dd847a4948785e3a50a67db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bd38f68925a802c98c7361f4d914b1b68332718797e6c7eb3a627dc37c124f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "027f82da75337791a459b028b0e00944d7c1029aa6c221a374ecad9cc2d7ba85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0676171e91a08c1aa9e99d5b8c77b484a3a37d9e5a0c7da498dd298b9bb53097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd2f77ddaccd7adee89df5df58a4e73f052b19deab65e5c5ccae5065c3634d3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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