class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.15.tar.gz"
  sha256 "e0c1640280b4af758004a285e0e0f5756715d7d851fdb178fbd71871731ac1b7"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99f979f575212e07feac5de965dc4d9e87671e86a226d51ed7e42dc9e35c8106"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e2fd97607784d1cde5178ad073a6110a15b77d77e2f9bb57ef2965c1844c2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fc66a0e1e945a570b5112eb1a136afafe4b3fe4c252c51e21f44af273c8318e"
    sha256 cellar: :any_skip_relocation, sonoma:        "688d8d481ec074cc7e9dc43f7f8dd0b4552254645ccbb31e779e42e668ef6dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c60bf5cbfe37ed5bba5dcf9b34ad32ce76a2d47a13a578a37bd242c1741c5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "128c7add8361361c39b527e910c0953f53a7daec7a1417bb57185adbced8ddab"
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