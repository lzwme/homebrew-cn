class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.102.1.tar.gz"
  sha256 "b018b0f447cdd88674d92659ddd1688f64e11a1c05a16773d8fa5a22072fd13e"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3310d58d8978b618d95a4fd85c4c7a0ec6e76718c6a7178c8daab0014644ccbc"
    sha256 cellar: :any,                 arm64_sonoma:  "4d69aeb6c0ec6140967486a9490f9c02881dcac34036ac55dbf79a65e7a2bb3e"
    sha256 cellar: :any,                 arm64_ventura: "950248d6477151e4e90755929a3985dd79b171d00f74c9e212ae93acca896a36"
    sha256 cellar: :any,                 sonoma:        "2a5e8a0995afe143cd328108d9b7d1e68febd12bbae1410eb241b3aff76f9136"
    sha256 cellar: :any,                 ventura:       "9175f61d8db6bac9aada3e62454317ad6263b9f2189d34c88ead12eef6ffe8b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c476fdbf76f86b680bfb4796d2d807e7384203e7441f1c931db7c2a02b80c3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "220353091156855532724ee5072e69f210ec0b51e519496e8889c81063dc404e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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