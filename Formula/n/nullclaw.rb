class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.2.23.tar.gz"
  sha256 "3d62e48612b69e58ce10294ca59817e052fbc21a5b081a1dbb0ae481af93e141"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe298abb85e7f6d2c75494743acd8bb3f4937bb2a6d197ea842d8a73d0534270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6afdb2c635285293ad67f2bd53ecc2cfe349de8a197a9f97e547d1145266ac00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a66ba85fad853e0208e9f75c85bf60cc8f8d994361c413621e3865f1422bd250"
    sha256 cellar: :any_skip_relocation, sonoma:        "79e4a93335046163370a3504239cd046a97e7c652179cb5c46145bf8cca0939b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1ccd36c9010f246626bc91e3c6ed005faa586b7ad00ba4bdafa6e4a07b0962e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175b1d01824e25674b7a9c5b72335bcb195dfae4c236d8a11b10a650400085ca"
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