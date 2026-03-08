class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.110.1.tar.gz"
  sha256 "9eb576005c5ab597b75e8cd573d0ea31e8eea0383fd46ecc10ff4ac254fef458"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d97b2063bb03c151f05c5d8853cf9f810f8f95465cb2a7154e395975d3cf102f"
    sha256 cellar: :any,                 arm64_sequoia: "24129f16221aa4edd52e27bad9fca2768780f9e10c876a2449fb07d903ba43e0"
    sha256 cellar: :any,                 arm64_sonoma:  "f059849d2b6fd1c5a6356256b25d9631dc34866f2e525526ddd419677f43eb26"
    sha256 cellar: :any,                 sonoma:        "f85ac748af58ad039780649023539268f2b9b2c9564d6abbcf4a79041ef82e66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b077ad1be071a0c5af42981f1f836dd97ca2051161d7a01996c0b8fa9005919a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0cfa522fe1a6a9949f65f71e4eb7aeabeb1600bc482a95ad0cc52fc2fe02ee7"
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