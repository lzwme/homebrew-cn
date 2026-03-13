class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.11.tar.gz"
  sha256 "a374c73c9e640cfb9462a1e404a1cd6995d11ccc1db461c7d97c7980d38b9aa4"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5961e6c0bce34ca7e95df91ad618cf91ccc0b9d1c1fea61cb8de24412fe2f72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f438deebe9730cf655110bbf96729b57500a0dd2e6cdf022781e712eaa088192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cbf2947b4b4f046125c919ada3d91c948bebb26e6b5dc4ed5939ea04c199e2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "663f0ff92d114509947a02d77984fb688b4f52dc5b1bcb5aa3dbd5eb17fad82b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a87d2ab06b2d3bd32946fc6f768ac2431e31ae921df0c0cee0084a0820a867e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c8a2d2dd97629caac7a3dfa8d47e3918a196a85bb5d9cf878c08d730b28465"
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