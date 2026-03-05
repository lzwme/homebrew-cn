class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.3.tar.gz"
  sha256 "3cf156197cf2ae5a25aab697dc5f83477f3ae30b81764c9ce343e0a632daf9ab"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd532e8b35b992fa2175670476d06aadc87b634afa2d8920328228d6b5e69e86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47a92dc24e451db2c85b5f7e521f20b60ed2d79a95c649a6afd163fc100539c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcd755243a06db6a2fa4bbf93c35fada0ae43e455882f24fa2f43bf361bbecbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "10d3f9332755704d178fa96cbbfb9085d0eca30364daedcf55b1773a1d75245d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f28708e896c60ed04fc35a6b377dd1211961775dc9a521e84f9351abeb33b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e85a58ca199279c912e5f3bc3e22f9f74c5b99ee4633ad8ffd99a76bc72b35"
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