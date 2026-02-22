class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.2.21.tar.gz"
  sha256 "397a775676e28390175d31a96248595f4637ca36008e3b4dbb0e7c6cfd4cd581"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbf3335b09949a724f5a9dbeb46981e0e07ba2e42794bc9f3d8f02d82cd0eae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37ce80189fde35537ac8b5749e3bebef54ba0a3be6614a406a4879b6a7938b3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3217d5922322ffef6d9a503411190acc37da80d98d1468fb89e7e5a0cb888a72"
    sha256 cellar: :any_skip_relocation, sonoma:        "22c34ae5b71b80cc70e0564ed1d5592bceafd770383beb990855f3f1c9aa4449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03a41960311ff4274a0423852a234aff185ba161c39341a23498088a25720db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1516d7eff02d06d0e35420953f45e47195751d4fe76ed80047a7091d45669120"
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