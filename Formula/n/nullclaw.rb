class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.13.tar.gz"
  sha256 "3418ef48a4994323d0c87ab390099b18f0f0c3fd8874d23bfd7aa5b373bc5597"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9036c5486ad0c3b7a48eb7f564ef2c6bfbd6a70541cfcd47fc877f0285df77d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abc13135dc00b7e8383c891dbef6b4c6f0feedb5485628fcabb5cc2fdcd79446"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c532ad3eb48287133a7e924c0f69e7e9307db5680f25341d9eaabcc635d030e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2603465685f301388ad0e8df525ec91cd61aad13c4d11f8a16fdd881272a778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04ae5bc3a59752984288d6f8237e567351ee76554db7f49a2bf74ca220522bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e268999630dec74718ec39618bdba89c268c092d5daf18ac8284aa12c003d5b9"
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