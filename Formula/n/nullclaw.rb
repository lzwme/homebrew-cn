class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://ghfast.top/https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.4.4.tar.gz"
  sha256 "2bfc0796ef8e419a88fdec034c87db1ba8d74bbdf90c063bae024652311da2ef"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a468da2b8eaa89da75b25b7b8b43a6fd2ad24e6334cb90c2e768479a55b59cbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2c0846093504df8b570e8821ac8d1a7c4d5fc68526f202d9d342f6f93abe401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fa425e6a7a9ddb2531e9924b6e1933c834b42bf97d89431767a00c55a8762b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "967a26723b6fc2b206e25c9573850c834aac608a18d40bd9dbd6bb999f52ea03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9581c22c1bbe62ddb62f0d97827f7e7bcba6cc953304cbcd426be86ba108a7d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca40302e828282fbfd25ab063b431d3d6b3f715a285d09792a9f28dcaa4de7e"
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