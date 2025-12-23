class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://ghfast.top/https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "13c1470e396c2aecaf5098a96fec3e2355c57213f1ca1c3aba3c70115f62df93"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c791f16c6de9d0cacdb94a82103c0b82911a7c6ab080f0b59242d04f13d2ea47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9dbd4c01328c1658ea2773da5530c26b7735f9d565ea8a19b800bf4154ef67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6700092d7df1a4aaef186308752dd3df62da2d64f0050e009e5023fc9a299ffd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c16fa9a787f883bbf2b0a5162b78c0b24d329154240d30ececca530de961968f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ecbc63f0e044fa3538555f12c6a8fd79a59e69f14eaea18a739c91dcf051f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89897b4f9820a2aa3bd17b7ba7e5b00b4f116f00e74623a3878b6b1cc07f83fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
    generate_completions_from_executable(bin/"gix", "completions", "-s")
    generate_completions_from_executable(bin/"ein", "completions", "-s")
  end

  test do
    assert_match "gix", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "ein", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end