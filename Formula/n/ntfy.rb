class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "1a80d255cfd1809c34d293ab0869b37b422da33aef2dbbaf201d5fc813e1d2ad"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85f0ab4c0815f184f473f9b58166d5df144bc211160c43d1c64892cdca3a61eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85f0ab4c0815f184f473f9b58166d5df144bc211160c43d1c64892cdca3a61eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f0ab4c0815f184f473f9b58166d5df144bc211160c43d1c64892cdca3a61eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "055c91ae2a80395fc4a9a61bfbcea3d959059a87fecc999a9cdc556ab11d82cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0de09c45e5fdcfb855b0859857f5b96d158bb3233bffc2871983b0dadd2cff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ea45865b2d079ee749eef7dc9bfde3f46bd0dd622ffadc89f0a548a24d08f0"
  end

  depends_on "go" => :build

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
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
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