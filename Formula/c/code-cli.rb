class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.97.0.tar.gz"
  sha256 "da8e79abab3bc81e5e06e9d6e4e3975c800b6955cef516ad23d24e6fbce1d6c2"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7dad0679cb8f4edc8f7c0ad4e730201be177b61c5a759240c6ce5c31a438bdb"
    sha256 cellar: :any,                 arm64_sonoma:  "c882f256ff3ecaf6966646034225a63eeadd2eef64129f0597a1d2d62e82134a"
    sha256 cellar: :any,                 arm64_ventura: "27eec9c4570f283d0ddfc3bf2c34d97cd360a1e9ec37d2730088d35c5cacc3fd"
    sha256 cellar: :any,                 sonoma:        "aef0aa8b0444b4cf73770597976a12e0f430dd6ba06317e1449bfd18cab848ed"
    sha256 cellar: :any,                 ventura:       "cc104ffbfd2db0d34d972e0f70c6b9304c324fe13caae4b82962f410fb02e0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d5f2f39cbd503cb1664b2cb5fe84d7a906504459835b5a63a4f91b45f8029de"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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

  test do
    require "utilslinkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end