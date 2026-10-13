class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "89562f86c5426696c914b8c4bb6821c6d7454b30b12e864fa9dada8ea367b1b1"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10686be23d759b6a1d2094c483eb06b3750bd296299ffaf2d616e1a028867eab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10686be23d759b6a1d2094c483eb06b3750bd296299ffaf2d616e1a028867eab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10686be23d759b6a1d2094c483eb06b3750bd296299ffaf2d616e1a028867eab"
    sha256 cellar: :any,                 arm64_linux:       "631b3408b88edb5c11be0f5a8f0f05ceefda9d6ba3d288de12bc83bb8ba4e3b9"
    sha256 cellar: :any,                 x86_64_linux:      "f453734e009efacb9bfc2516b31e2bb737012d1cb8938d8a626b1bf29ae4184d"
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