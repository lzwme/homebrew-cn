class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "aec6aa2f5c329c18fe8882031934fceb527727989413d7f1604ab8e2f8c051fe"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79e6b2df6d0bc7b8930c00f76f6d29bc2ec0b6979db7491d81d3b840231eb77f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79e6b2df6d0bc7b8930c00f76f6d29bc2ec0b6979db7491d81d3b840231eb77f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79e6b2df6d0bc7b8930c00f76f6d29bc2ec0b6979db7491d81d3b840231eb77f"
    sha256 cellar: :any,                 arm64_linux:       "aaee16b841c6cb9c5f0d7e8ee3d3e87bac0a976b7c8c5230e005c2c50ae51967"
    sha256 cellar: :any,                 x86_64_linux:      "ab8e33367437247b1a30bf586ad995b2e848edc42f1c23db9e935fa8224b56d1"
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