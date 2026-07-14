class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://ghfast.top/https://github.com/aaif-goose/goose/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "6ff6d1bbe31593f046d764234f4bf9be948a06ea3727a089d9890ea99eadd7cf"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ab751fcf3d17331a9584f12b930484c2217be8c78273c7139f3c25d4659ee74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "765aae81c0d3a24fe96352ea84a427efd0b378328bf20195689615a0f35686c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cdec0b3e056cf64929f6b441d1da2bd1d5e6b891ef418c3882e962f69170d2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5053d00d73b3cb2a69d5ce5297563c38d658db9cdf8a0d03084e7dcdc7029c9f"
    sha256 cellar: :any,                 arm64_linux:   "9cc88b6c0036c92f1fe1e00bb9bf3b75b6d61fdf346f59ce9a9192bc5bc4208b"
    sha256 cellar: :any,                 x86_64_linux:  "a4c13fa32f9a77de5ff13b5c79dd5f105b837e7690e92ad0e7c1bddbf6c7ef05"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")

    generate_completions_from_executable(bin/"goose", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end