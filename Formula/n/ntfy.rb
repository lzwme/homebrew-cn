class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "c44b6589b448c0096f5dd34cc3c6518ba54bc12d86fa10750725fd42e11695bb"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b39ddf7c2b53404f3c463db0b604e119753dec8a7f357160536be02a280371ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b39ddf7c2b53404f3c463db0b604e119753dec8a7f357160536be02a280371ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b39ddf7c2b53404f3c463db0b604e119753dec8a7f357160536be02a280371ff"
    sha256 cellar: :any,                 arm64_linux:       "3376a819cb78080627d42566c1f5c8dfbe634de41b5509519aff4bbd04975db0"
    sha256 cellar: :any,                 x86_64_linux:      "5c872ca978072a5436364301fb372c87b5e20704d648f875ccbefa7eefdfa4bb"
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