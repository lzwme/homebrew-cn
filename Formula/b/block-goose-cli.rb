class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://ghfast.top/https://github.com/aaif-goose/goose/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "4637e38ecc9e9ed88ac0c6d53c17cbe445ec02501454c7c5a99335b14e5b4617"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d26767e82b41d27862d9f73066ebbbff7edb217986da719047d5808efe77b2fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0494b4098eac6919f5160820fd6d21d02ea06fea9a5f75bf0fb77bcdf36ba423"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3193679d02250274b1c2c974f93b95badfc93a9e75cfbdc5a36a963221003e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8c2d553db95f6258f934d2dda8faf49096973456d5dea16441e77ea3131e0fa"
    sha256 cellar: :any,                 arm64_linux:   "b2e96fe7b0b24a391d5632b8bb546927334ca843af7f213adffc5321b40bbef7"
    sha256 cellar: :any,                 x86_64_linux:  "2d85294f1afa9e4563cf0253cc958edbbc9dd34e02a4cb49cd24de095a15a2ca"
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