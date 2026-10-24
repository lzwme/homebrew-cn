class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.33.1.tar.gz"
  sha256 "4e01033d0acb08608c82c3e9b5a7e052a9b929c2285dd8b927e2c39e383eaee0"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9446c70e745326e10c233583512d229c8963b8be199be85f0dfce7f23a1204a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9446c70e745326e10c233583512d229c8963b8be199be85f0dfce7f23a1204a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9446c70e745326e10c233583512d229c8963b8be199be85f0dfce7f23a1204a"
    sha256 cellar: :any,                 arm64_linux:       "c2f8a765fade1001a3bf07d1dd2add065ba07d4e9dd8850442a319743f02c2b0"
    sha256 cellar: :any,                 x86_64_linux:      "2a5d3085e3100b62b39d60d029ff021fae1fdd3ef0956c6e27e3fa20628f2581"
  end

  depends_on "go" => :build

  # `test do` block publishes a message to ntfy.sh
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    tags = %w[noserver]
    if OS.linux?
      tags = %w[sqlite_omit_load_extension osusergo netgo]
      ENV["CGO_ENABLED"] = "1"
      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arm64?
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie"
      end
    end

    system "make", "cli-deps-static-sites"
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags:)
  end

  test do
    require "securerandom"
    random_topic = SecureRandom.hex(6)

    ntfy_in = shell_output("#{bin}/ntfy publish #{random_topic} 'Test message from HomeBrew during build'")
    ohai ntfy_in
    sleep 5
    ntfy_out = shell_output("#{bin}/ntfy subscribe --poll #{random_topic}")
    ohai ntfy_out
    assert_match ntfy_in, ntfy_out
  end
end