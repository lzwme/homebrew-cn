class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://ghfast.top/https://github.com/aaif-goose/goose/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "a0cbb202a0edd329e8aed7993f7b60f940296a633ef81bfb7e1c092f2ff53fbf"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b04630af645acc58de8c217c5acd6074b4fe9bcce1cbdc433b605f8f4296ca1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ffde36a703d8818561ee0c6ec3e21fbe805402b045c0e22a2ffef612af20bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3616b588a2eeefc1de24559db8b62ea1f5cc5e0765eb72f3b5358e890309ff07"
    sha256 cellar: :any,                 arm64_linux:   "143f6e4d1e46ecda278a6a3fe2000e1f470daa53c7a2ea62a65ebfe18769d654"
    sha256 cellar: :any,                 x86_64_linux:  "307c137040db3ed22f90027cacf1e2ac39b6ee70d9484d611476d6cd5e09f30a"
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