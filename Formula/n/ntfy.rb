class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "3b8dc540ee0e4dc6fa66457461d8473d549616530d0105e7eda9c8657019ce1f"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8bfa4b1f26af52232898eb11ee7bbbfe128ddfb3a58c81501c069791ab70c0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8bfa4b1f26af52232898eb11ee7bbbfe128ddfb3a58c81501c069791ab70c0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8bfa4b1f26af52232898eb11ee7bbbfe128ddfb3a58c81501c069791ab70c0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b38ae8ccc8fc0fafee6803015ef5cfe417210d4976b68aeb0a4140ac741335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38019a016cd197628658c8bd92fff89f012280952e7a084423f0e44040c67d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5fc5c5321cd380131a12616bf4c0660e51ba0d52de2b320b73f3b1ca4a16f7"
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