class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://ghfast.top/https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "a2761fa1a75c696338e9f8511c1eef92ab2540ea26f7e74d446b9cf2f9ae5569"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07445f87b0b27c0cdf6ca6ccaba0a98b1f66942782845d9b3d8956f6475bdb24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23538548bcf9652c060424160372c8343e340b0c81d5bba31a00c64c458afd02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c11a783389afc387834700b01a8e81dbc5bff722b06330012fb1620a3768927"
    sha256 cellar: :any,                 arm64_linux:       "2ef6adf077ecf7cd4b0f64ec86c74d19b7082486e826c632037f1d9bd7d8a9ef"
    sha256 cellar: :any,                 x86_64_linux:      "8d4a365121c0724324e182abbf219b04e0c7de7ac0dae0720394831bd622b2b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl hashes]
    system "cargo", "install", "--no-default-features", *std_cargo_args(features:)
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