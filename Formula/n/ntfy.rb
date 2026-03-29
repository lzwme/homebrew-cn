class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.20.1.tar.gz"
  sha256 "d744b0690bc3b6127c7169ccfd45e53d34c29b583fc47102fda06bb7a3e73abb"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e3d09a926aa8ed11071ad0d3ea2afd9aec591831086f31ee504e21f55f0891f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e3d09a926aa8ed11071ad0d3ea2afd9aec591831086f31ee504e21f55f0891f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3d09a926aa8ed11071ad0d3ea2afd9aec591831086f31ee504e21f55f0891f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f69bd9d9ecfdbf2b0e7a68b4f24da50e43ef0dd3bd8a3c9602989faeb01d309d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fe4862aa04cc5735ce3472285f47b58c424862f1367f8162b526924c4c1a96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4fe6c372e7f1fb8d556fe5a77aac0d8c923c9facb900f2854bdd5e7fde27eee"
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