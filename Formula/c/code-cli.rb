class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.127.0.tar.gz"
  sha256 "99932538119abb1bdee473aa654bef7e2e424d897732a34884484ac894160cdf"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8438b10481d6d143c9e774d0dd0eadd04a45e8c3201418dd56be379eb3181119"
    sha256 cellar: :any, arm64_sequoia: "57bede7aeab531fbb9af69964f84171a2148e46b1bfa454bb34557b6be479ace"
    sha256 cellar: :any, arm64_sonoma:  "ad6693d5309c767409e235ba3358340367bdcc7d10a9f1ef48cb1825410afbda"
    sha256 cellar: :any, sonoma:        "3834c73dd821848b818c46f1d641f6dc996b5c436a40caa9a3f0fbb4224e700a"
    sha256 cellar: :any, arm64_linux:   "561921c581a3557afa4d94dd220b6a4d5adfb9534614ce125258c0eb02457c0f"
    sha256 cellar: :any, x86_64_linux:  "3a07094b7a029e8fa9f5dbadd17882a3c7edc70a14bd01082b8e9ef57e43d487"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "visual-studio-code"

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

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
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end