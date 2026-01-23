class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://ghfast.top/https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "8ad0fdcfa465fedac7c4bafaae2349ad0db7daf48a80d9cb2bd70dd36fa567aa"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1999efb9ba72e149f3dc4a717013a678ef4b37e2bdf0fffafde6ebc75b6d9a93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44137ce72ee44354493a8582a4df6713fc6b23cb368a7386782e029709b7ca6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bddc1fe73a6c46a84ca9fb66cd145b029a63f980e299bbfdf41493fd8072fbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "1de2a5e170ec12e051dd50b13a41fda91891d46463e025c7331b9b5a9f2d9081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3342a3e2b1971aee7575147231a6a32a0e255db46017c47739504a3025c583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1de421e2752caee925da0824a8fb607bfb4486ecf8ea5dcb9978140461997798"
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