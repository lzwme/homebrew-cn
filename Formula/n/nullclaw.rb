class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.4.tar.gz"
  sha256 "5f38120f5409d4f7d011068d4b0b4c472b54354b1e46cecdc928c46b9acf2e55"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9772f2d42ce059b685af389c9ee3360e23ef1b577b69719d26ccd0fd6b24c8b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78fba78f86ccc3c77533cba6f6e4d27181e6149fdd56e0d6a53a6c192d806f11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae08cb0dc6fedbd1407c8808159160a6661144134d932a4dbd1fc621a8de99c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4ff72626b8843f03c519828c4fa144de04c87508b5ee01e49fc7f608fa5836b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "791b119f0d6f1d6db58fa0e688cf4ddfe058752b2ce69026d4eb2d4afe772501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc44498c4af09455f4827582bdf39e09a2fe89fb1acba875fae55435723fca6"
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