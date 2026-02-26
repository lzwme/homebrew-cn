class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.2.24.tar.gz"
  sha256 "c348028d4e92cf7dc1e4ed9875a75f58db9247553ff9c7b0577854da5d1f657c"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a31ffee40cf853908735a4b2728592781c4e4d25df63030bcf852463546023f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f9c3ddc5329cba835472849861b245837c47377c3a204bc5c1a15640a786206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01574b9ebfdefb27bbc7bc76b2b19b96c70c8b0ef50da5c7263939aa06f90047"
    sha256 cellar: :any_skip_relocation, sonoma:        "949f824660d8e6c1e97277dcbac4b27ff18d559c6f2930fcbe74d931a2930b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5da8733818bad1b8c8caaf39f3863d4ac818ae44d2d4ba038821d5a78f4e479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e8c3fb79d4ed6aad6141c605f5d7bd643590f280337c0c045b36da8f1c3b49"
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