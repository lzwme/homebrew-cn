class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.17.tar.gz"
  sha256 "4c4cc057f84004509a53ac1712c846131f56d83743c4d0f347a76087f06c7342"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c05d0a2d914320a77dbbae1c3fe6bf6c194e79c5ac1dee1ab48b6c46870ded2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c00efa088f10111131206c172fc1e75ffdcc532f3a4bcce87e5145f5e860ac25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f378a09805e7f75f6cae02b9d0d193b1d6ac8a5d9e4fcaa004ef0d1864105847"
    sha256 cellar: :any_skip_relocation, sonoma:        "e01e3c3fd2cadbb8b375d18cce0ede11155341f7758ae3c0646b6b99f34a8ac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877668c53002cdc9526021eb5c7ea5071dd46be53f5ff1e21abbba597f4606d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da224cead3e691e2988344518ec3f39d48a0b0cd2f9aefa6dc54cb4cde0829e"
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