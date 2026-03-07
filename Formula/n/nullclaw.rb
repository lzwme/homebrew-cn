class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.5.tar.gz"
  sha256 "19ddd8c60ddf78d7fb72ac41d50000bba3ac82f89c34502f0b18400412f590ba"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8a6e8ae90b7c6c9f56ba5c1804721b277ea0cd512681c7d378b157c31c15cca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc84c192e1c72484d2abcfc93d373624a3ba4a0135854ef073b39c4e2cac1d75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20dbfaa503fa048d3b10c79fc9457acee7b6b127bcf08bb196b9960cd3cb7bef"
    sha256 cellar: :any_skip_relocation, sonoma:        "de643d4022cfb2599ce46a94f8a960153e468355c7a4c8ddb48cb2dba8d0590f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18caedf7043276b1ea27aa98bfacd9ea247b54013bd3773189fb12eecbcc05eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb65c33db34a993bc5a008a46b031ab830ec979b2144f5418230e0620df30902"
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