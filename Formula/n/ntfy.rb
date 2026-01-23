class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "b564e16166711a319a21cb5711e2d000ba0332454c2af8aaa168b2b5e77ea8de"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87898a8c67fc7ea901c2998e49a448b4d82c708350bb27bcab46b99133d5b346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87898a8c67fc7ea901c2998e49a448b4d82c708350bb27bcab46b99133d5b346"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87898a8c67fc7ea901c2998e49a448b4d82c708350bb27bcab46b99133d5b346"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc5d404d40e788b159f95e6f06143ddbca4976c88d58a4c371d13a7457178c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de944b7a77ec466f19bc5b3a00541325668310777a6ffdc1ae812bde19a9718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a8fb15f130aa526d92ab34681f06279066cde7b223994fc1af2c5f0fe456f1b"
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