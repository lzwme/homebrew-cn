class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.81.0.tar.gz"
  sha256 "ef970f1349b467ac8b63e01d9f9bad81f7d5088c01f55919f0b21f12a46acbaf"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f1afe5d3aaeb6e57b7da99c2775ef6ff4f1c72a81213f20d625cffb7685e74b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79a20f1704954e290dbde432f6411bf4a68df874858feecadb8a6bfc8ea52730"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a281c873518b461bd8dbd1602c03661eb3dae67028bdc7b517022d4191a87fae"
    sha256 cellar: :any_skip_relocation, ventura:        "bf7181e2f67619ee5321f2def7144762de628b69e824ae9cdbbd8f9ce07a3909"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c864570ca709bca06dc6897e900edf851d871ed898dea73f60daf7e8d94e04"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cbeeda4a7df6ed7b336f8cc9ad0071e193160253b7fcdf1b885b8389751ee43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a83787aa13bd5bf0222ce4d383b3ea8548e6bd61526c886673acd5f0ff0f1bf"
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