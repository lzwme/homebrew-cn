class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.10.tar.gz"
  sha256 "bf5d8f34c106317214ec1fb7db8f16435ff8786ab0808ee22886df79b2167a3c"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e92774b7fd476e78c3eb98ea6246a64d08d0490d9b3402d1ffad382eeaf9c83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9297cff558f90d93dc4a2df23e52a69d6bd65d78346a8a1043a1b75dbd8d20c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1b37b42a52a3c40bc4c10dbdb67379ec971196598751c7a50a65a9de3e9bdfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "37795045d7ee8596bb37e17b6fb3bf4fdc5bd88c9afacc5fb681acfccea36757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a6e69f797594a021bdb3dc31047c40b7d439328f7aeb81d01a4d5c5b8bad888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f78e3ab8c310194c5362a0dacf1160c744a91dd4b578dd6851128a80e5abe2e"
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