class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.7.tar.gz"
  sha256 "68cb097138e1114c8f074e09ca8450bfd1f380ea4987ccd53dd1272bdd761dbb"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc3e10fbb29a8fcccfb985149771fea0fc19d13e7b963e2a3146036cde3421ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5488e03737b51187a6fa9d3cbd729ea96a631c523a4c47ec4afbce857b4306d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e1abdae408bafe052f15a37b5d9206f3f8bc0dcf1367a2a93e0fe9b2c5b4c20"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b3fb347405c36a762d6a834652990de380fbe7dccf8777a00c68e3fcbfda393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b7e87a50a212c08538d1a05cf6cfcb15c394feaa37c04facfa0135595c3550d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2083f7e0bf8892ebe4ddd6da3754fc9bc649e3d89c4ac26ccd359c70a4e36585"
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