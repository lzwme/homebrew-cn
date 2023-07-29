class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.80.2.tar.gz"
  sha256 "10019f2719ac22ffcf2cf2ee77ad4d44dba49563a867ce88f9041ab7a2335200"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a2f2ce8f341c90bf1db760c04be2fa22df1ba22832f0c6d00596b4251fcf998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af149b71cda10eeb37acc46d596681e0641d19c0f252bf1f07c3ad8feb6e5fe1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "124b5b9a595c9b0efb522eb240e146540fa841763d9d9700cd264d492e37e021"
    sha256 cellar: :any_skip_relocation, ventura:        "025448ef4d1fd755db5020dd0c52ae51a6372aa90e9b18d8b07f64eb412a4b4a"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f070ada73b589129e8e05e70b9eb7548a1f40ca020dd3600c2c530e9439b02"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1d8d40e544ac2aa6103788a9f43e3133e8cd81bad0d240e5f4e09707545fbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35f2495a3c59acfe066bf9f2acc0466b3198cd998ac7df8cf39d10e7d94f759a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

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