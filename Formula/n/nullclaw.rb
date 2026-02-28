class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.2.26.tar.gz"
  sha256 "a9ff635e88d759b88c5ca1a443a42a410538112f7392cc8484e88e1a442ff0f4"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "613e1540bf87f630a9871c28fb46807bf9a961e507a09dfaedb636cacff708f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d14d6505eb13e9dce912b413ee401a6d31e9823ba93c745211b037ad1b5c612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1af44f66f71e45e56f8f7bb168019366b4cf3c0836d825e4e9ece03f6aa19cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "79fab00fa7e3e75de91fe207ec0a4157ce996d83dbfcbdde00079ccee5516d54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12fe42b7ff28afae333224484f2b8a71fab32d69d0190e697feea36bea4ce2b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d131004cb26b9fd2576e426085c4d9f11271c6e4161d710b84f9f6c0bfe35e"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = ["-Dversion=#{version}"]
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  service do
    run [opt_bin/"nullclaw", "daemon"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nullclaw --version")

    output = shell_output("#{bin}/nullclaw status 2>&1")
    assert_match "nullclaw Status", output
  end
end