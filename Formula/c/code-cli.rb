class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.119.1.tar.gz"
  sha256 "1c85c8932c5127f40b48a0cfadd43fd20ce91c8bfde2f263adec65c53f931e32"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f25bbcbadebfdae911d5a59b37d797b308ee4a1efa2ef9cb9d4cb95f67ee90f3"
    sha256 cellar: :any,                 arm64_sequoia: "7d63bbf67f9bba48a4ea00f4fac36628fa6342ecb72761fc0ecb9bdfff8a505d"
    sha256 cellar: :any,                 arm64_sonoma:  "4751b2bdef2c5eacda2ed53cdffd08db3755fa1c9184892dd10f7ee7b5744acd"
    sha256 cellar: :any,                 sonoma:        "c525854e3287c1e48db722deb48f79047a7043f31c12f1a06add2bff8358d37e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f1396ab6cbcc950f9bd14e14e5f1de5aa793692faa79caf26318f594249ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d3d35b694b941929750e072032d05d1eb0652894dd51501133ba15eb953ca5"
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