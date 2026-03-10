class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.111.0.tar.gz"
  sha256 "591246c3f17b81d2062e89fd757ce92be6910ed02b0adb8de74d12d1e655a0f3"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e00df0bc7137eb6bb656c0b0f982f6d5d309b808b2c5f123ff02a509e63e1638"
    sha256 cellar: :any,                 arm64_sequoia: "b0727953081376e15af767805d14ab339a43c368f83d6670fca12861e1ba1da4"
    sha256 cellar: :any,                 arm64_sonoma:  "1029a389632ac963b55af3af853488a7baf10e11d320151b10a5307195fa67fa"
    sha256 cellar: :any,                 sonoma:        "3727c4c180db54c3e2f9e8714f005feb7bec744ce52bddff3a188d0219159d51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6ea21fc51a16c2abb1224748f88d02363d187dfdd93898fabd3aed0d228c4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d254ce701b2a7ba1a4ef2b7f2d755bc9638fefd49ee5d629a702ea4967e6e238"
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