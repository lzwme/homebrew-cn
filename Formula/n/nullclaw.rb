class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.8.tar.gz"
  sha256 "51d807772e5cc8f309f44886e69a54114b6f9f808dd6722bbb8dc0d7cefe81eb"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8cd791df4295f6cc7665fd2c028e3cfe6a6a888fbc1a15ac52d1f4c1b981256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ea8b7f7c26a0076fa3f7bccda3815086fdfd0f2674d8460a7928f7de9e0c4a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc8419e244d5ca295a58b47de1d708bd9ad2c04eb76c7f284438505941ee87f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6a5ae9683820b1cbc0d08e0619bf70ac75030e88055e74548b8e9ffb1c0998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adcbbf56174ee91dbb761b6b0f06d075e79826db815be25c655aac3497c5ef14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c79037d21a77e6a016d95244761ff7f6256d6beafab9d680ed5d7bd984d56757"
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