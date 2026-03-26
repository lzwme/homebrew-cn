class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.113.0.tar.gz"
  sha256 "c56a5a7933e1af0b56243b050e504d8f3fa41eb4867af700d9e836a39611975c"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c7716c337842f6ded79f5a40588396db6310437c47b9810b2d26794c39db04e2"
    sha256 cellar: :any,                 arm64_sequoia: "b34c8b8dccf05521dfec0188cce1885fa140f9c79a2d50782095b1523fb2b2bd"
    sha256 cellar: :any,                 arm64_sonoma:  "7abaa159a9544fd8af3a07a74259040f87f14de90ca41cbaf0d3d00ecfeaa9fe"
    sha256 cellar: :any,                 sonoma:        "119968b59d1e5ad4fe70c8549f4cb11972c9b262cb35a0151c9b4b5c2c931bbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aa3e4e3088b20b6f9690c2dad3d23d34bcaf7d0c40b5052cbf19e0fdbce6565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "795886ee9446b6f8e7d5aa55240760b97e5f70869b2e7c968b8610724ff7eb16"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
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

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end