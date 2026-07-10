class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "951735aa0b81f7fc48c3bbb9c89510017d7dc73abd55deaeaaa9d79ca4279f18"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1e3bb499ba05532a42bd392618966e4bc588085301e9cb929e8702196bd4479"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e3bb499ba05532a42bd392618966e4bc588085301e9cb929e8702196bd4479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e3bb499ba05532a42bd392618966e4bc588085301e9cb929e8702196bd4479"
    sha256 cellar: :any_skip_relocation, sonoma:        "8930d9c3d033bc4605590a9240530579004b95bfa3a305b150c5a03889278537"
    sha256 cellar: :any,                 arm64_linux:   "03dc9965c80c2ae231a7e8b2b73cf34dc698f0e8febf9a878950c39fe8f68dd4"
    sha256 cellar: :any,                 x86_64_linux:  "128e5a39655dd29ab56dcfd10c322665c0247e9a937bc34442a56224b4d770ac"
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