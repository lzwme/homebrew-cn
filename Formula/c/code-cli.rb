class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.86.0.tar.gz"
  sha256 "7dca663af6963cf67cae936cc194a2c0510bf13cabcc705b3b6de006cbfb348c"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8ebeaa9f1c9383dd8ab68d86ceaf77c54831fa2cd9a88127ea1d45929f55cf3"
    sha256 cellar: :any,                 arm64_ventura:  "1948819f176d7ff12be2a1a63273177cdeb683e1dea68ab646a59000ab56186e"
    sha256 cellar: :any,                 arm64_monterey: "c924e19d2d74dce498df3273a63824c4c31048a1b951730f566df4e7139794ff"
    sha256 cellar: :any,                 sonoma:         "60d0e9d92af00a45624009b8b31be3b2234926386646e08590b1ad6e1cebede8"
    sha256 cellar: :any,                 ventura:        "6ad1669b699e358fcad0862ced57c7a10e137be3af8e6b1c583d006815c47b62"
    sha256 cellar: :any,                 monterey:       "fbb5db1463edffa24ab8573ada8fac44a1d537d14e3f4441c91fd04ad4b049c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da27bb6b7f96a4c0368591150ac0b1bb4368f38fbd78bf830b280dc5e75d1b7"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https:crates.iocratesopenssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_libshared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end