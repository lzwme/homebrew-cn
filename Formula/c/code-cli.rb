class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.82.3.tar.gz"
  sha256 "07ee83821678167b9c269dd2f943426f8fe192700acaa398574128043415fe17"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed6d5c90594ac7953f9599b0e479b729533ddd32e69baff3c7d8728d5e9bc27a"
    sha256 cellar: :any,                 arm64_ventura:  "68078bb6f4e441c5e0d2f1548364f0491c9c546444a2628d5c4231b224e0ab9f"
    sha256 cellar: :any,                 arm64_monterey: "bb55d03483387791d7307506aaa2c805e4962f0c241c79bd7bfe7dfcf5210220"
    sha256 cellar: :any,                 sonoma:         "81cf2313fe219df49bcdf9501d2b8a4d5f0728094e84a0a99e8ce67b3ac54c00"
    sha256 cellar: :any,                 ventura:        "7156bc817ce7043b152df348ee16383882f234b9c07498ea1e90ba1e9d31f447"
    sha256 cellar: :any,                 monterey:       "862c42e580baf7e48da62cafe4cd952d84a050cb7a4d8297b1e775baea33a715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c5e91b8b309d74a8b4a6062dd6a4e7e628f75c4806df4d251870a38c1544dd"
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
    # https://crates.io/crates/openssl#manual-configuration
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
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end