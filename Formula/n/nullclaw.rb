class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.14.tar.gz"
  sha256 "1b9c2242e6937d499f4b1fc1d4039b0f11330efafc891e67c210a4196b7649f3"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2748b60d4297bf2d07e0a9311a3491abc199a59b8800d7c59fe7e875a42757df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c799a838cc87cd2becf8b58399a984c4768fd770b4eb1c67abafd83b8a191298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e5c1f426110586baaa6928275cbdd19555830ad07131b8cc732cfc70381301e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b314588eee138d25ce38b03810bacd6cb0bf0c80096a1f1e66e27d2eaad73250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d21b1e98a14d5243d250d94ac7fd0b65094ea916d9499d292dc4356410c0272e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a5d8d11f3244cf6869da203459acb8e563742632e7a392482bfa6cb633b24d7"
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