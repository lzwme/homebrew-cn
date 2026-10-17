class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.31.1.tar.gz"
  sha256 "a420308e3ea7fca07bb682eedc514e94eeaeaff7afe9839981091686dd1984ec"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9db009b061da37079f5a946884a0b21d50f090ebc37540c68acfb61375417224"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9db009b061da37079f5a946884a0b21d50f090ebc37540c68acfb61375417224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9db009b061da37079f5a946884a0b21d50f090ebc37540c68acfb61375417224"
    sha256 cellar: :any,                 arm64_linux:       "633db65ce6c2a59e70b2a739a5446c4353908b5054b18a67d9701e17eab3903b"
    sha256 cellar: :any,                 x86_64_linux:      "685ed9e15f2ebbacefca6a0148e669629977a4d753400a88d717e26b67a29765"
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