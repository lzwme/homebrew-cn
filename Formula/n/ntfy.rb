class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "651b7837b564929e843f4e6af2758eb20768335aac0a2f58481a6bce0e4787b3"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92bc6723764cc1c2e9224b4204341ea5ca5d3870621d7858688d57d582b83ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92bc6723764cc1c2e9224b4204341ea5ca5d3870621d7858688d57d582b83ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92bc6723764cc1c2e9224b4204341ea5ca5d3870621d7858688d57d582b83ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e28a004d7ebeff1cfd1c2641d61ccfe3a02fda74441dd7b62c05c68fe3a543b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42c6d351722d6032ad967f8abf1e4e512084be03ff90d2eeac5ec9557cf87703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e498cf5aec3ae097af17e83884c9ff028580d92ef2e6f52eabb04a6a182b75c5"
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