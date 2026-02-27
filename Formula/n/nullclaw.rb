class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.2.25.tar.gz"
  sha256 "fb003a191610a8f6ea43519d8d329d7c46a85e6dda6c1d2a240488b3fe9e4ecd"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfd5b9b91da2c1c6c90b26b7e6b7ab74ff9af9c7708ef7dc68aadc91288ea553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d7c8c2ec05e085519aaaf2be7409ec43e478a9d763b4e494ce5353a7bb72ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d298591fe9bd47c980990afda2cf1e9774a2609ba380e5736acae2cdbf7a8c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ce96db9953270e7c7869f844f2a20e3b8aa8208f84a84e9e039aa9481a6cb5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "330a199432aa27e3532cc1b4d405d4f35fb2ff2a9c4c61e13acc751567b01e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "122fa4572df4b091198022f25dbac59538abb3e83c6a0d9682f016cd6897c284"
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