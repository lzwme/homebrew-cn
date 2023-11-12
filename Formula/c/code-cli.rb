class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.84.2.tar.gz"
  sha256 "01b28abc554fd6999eb5f7fbd999c659f5f98924c3a71dae2c7e7bb5bfa0bf8d"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "418da2f11f3b259dbd42502559413999cde3f81c578896f684eddb2e7b8ac048"
    sha256 cellar: :any,                 arm64_ventura:  "9581e9ce142cb2629e44544e26ee9e3801a2ce84cc0a688e61b917011f308fab"
    sha256 cellar: :any,                 arm64_monterey: "b077e5d20c5e0de2bc5dbdb5ff295763e9472ab1f66db5fe348f5446208ba269"
    sha256 cellar: :any,                 sonoma:         "70b209a27fb58dade57ce5a7aa013be2385fa7b999c162b26df164f9cec29dcf"
    sha256 cellar: :any,                 ventura:        "3f6a0c23cc13c6df4d8301b7db0637bf57951a771eedb4bb03a1148afd2074fb"
    sha256 cellar: :any,                 monterey:       "7b80d21ca24ca7e21aaa3ca54257252d00a63e20cc1dc79f101a8844103794d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e057f1eb151d628c5f501b6cf833d3129258ad5efb8f77cb6889b137ed9c70"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with cask: "visual-studio-code"

  # fix version report, upstream tagged a wrong commit
  patch :DATA

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

__END__
diff --git a/package.json b/package.json
index 6b56888..64d1b4f 100644
--- a/package.json
+++ b/package.json
@@ -1,6 +1,6 @@
 {
   "name": "code-oss-dev",
-  "version": "1.84.1",
+  "version": "1.84.2",
   "distro": "ff0198cd90b25ba7ca853279cea9b8bb3cf5164d",
   "author": {
     "name": "Microsoft Corporation"