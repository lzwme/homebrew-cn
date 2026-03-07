class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.27.2.tar.gz"
  sha256 "e2904bcebaef880bafc6177dea335f1d51aad5f104ed21b37936be0995bc4f40"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33ae6c5c167d12b651d89bee0ec0cab0b770d841f601a7556824058c58e6f861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60fbde132024c9e7a5054c1e5890118e17750ffe660cd42c897b3800468779bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e06f0dc687355902edc697d8e62aba7bac78efca00250c94b2d4998c51669d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "16c4a00529ab20bf0d98e897c24ac67c30bbe6c2cf3441ea41636fa0bd8a324a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2152219d4a95589799ee16fe66da083b34863028df5331f3b85e5971839afd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35d4936bcb263cf68c3305f9825630f3a6fea61d2225d602673b5c6f8311e86b"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end