class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://ghfast.top/https://github.com/aaif-goose/goose/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "fe57cf8d5f795c4be0c90d27ffdcf9f2443a2d54e90488228ca2702513c98d02"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8155c22fdbbc974309b77d3d6bf6dab8d1260e5ff38ba8949537f91757847e64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8e134ba772faf1691ed6313d0e7847edbbb19a00f0eb9b9ad844703d4410c6a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed5d751f0b727069e492044204d3a8bc5bddd47915689e97af177350851c4ea8"
    sha256 cellar: :any,                 arm64_linux:       "c896180645e3b3c0ada9f5529e0998ef52aa4f0bf328bd358e16ecd476207746"
    sha256 cellar: :any,                 x86_64_linux:      "40704b71c1942403de5d146bb3a8af0e77bf68484ba3a7647be769e50725a535"
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