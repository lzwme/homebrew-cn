class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "f8bb579750bb7dba3fd8685a27b4986f7caa2d629f6d80cd7879308dcf540c36"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80f0ed140a53f80dfdb6644e1bc4d249c950a3de1ccf087273b29f93f2138cfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9223dc8abb6c0a5a5b3c9fc1ee866016016ce96d14776e2a7aa709a0723fbe5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d5ac4ff9140f63f2f2208f7ddb539c44627da6cd323f1221923e42113f2aeae"
    sha256 cellar: :any_skip_relocation, sonoma:        "0872653fe51fec3f2f568d7a74603e5ff2176afad4e6f215212b3dfccba6a34d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c663c70fab6b3eab217322355ac584349b9c6ab8b9fadc3441f4ec9f967b1b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90de9383ec3c6144869ea9ef399a0ea584c212cc3a893f3358174df2c6f6dc4"
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