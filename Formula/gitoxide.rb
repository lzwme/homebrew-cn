class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://ghproxy.com/https://github.com/Byron/gitoxide/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "098bb18e1cae42ab7597b6b442538d3f51b57935a848ea121e20e2921d6a4693"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50cc3507a201317ca4efcd66ec1ca950e7116327ab5c9db9679e8c67e5f692d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "775e274a1b105542f6bc761fd1f8497b1e7414b0b6fd25ffdf7ea9d54530694c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5dad4fb5bfdb7dcc43ead6595a953729e8315a1482e038a32cad68d45e965e5"
    sha256 cellar: :any_skip_relocation, ventura:        "499573e3931e0c8c1b19227ae324d121a236c789447d6ec2242009d604935c13"
    sha256 cellar: :any_skip_relocation, monterey:       "9e93326fcd0a656d7a2aefde7ddbdfece5f9b99b00520f4e1adabd9c1c091e91"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddc27d56225489774b1ef7f4e620fbda93870f49ca43288fcd129198f7152b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "265373aa1df3eed94736023ce31f79f9670d37f242ee5abf1c5e51993998454e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Avoid requiring CMake or building a vendored zlib-ng.
    # `max` feature is the default.
    inreplace "gix/Cargo.toml", "zlib-ng", "zlib-stock"
    features = %w[max gix-features/zlib-stock]
    system "cargo", "install", "--features=#{features.join(",")}", *std_cargo_args
  end

  test do
    assert_match "gix-plumbing", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "gitoxide", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end