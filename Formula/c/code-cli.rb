class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.95.0.tar.gz"
  sha256 "559e3181db15fb1b463a8a386a7b3a82315642b40e6f49565c74c4697ef22457"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef1c80be3b6b0052254b058875d7e5e43c76eef9ed3872e1a71c37ec74b030e9"
    sha256 cellar: :any,                 arm64_sonoma:  "3ae2dbb07940cab887e22d6e32c6f4c7bf25c0453954852dd226819f3b9c637c"
    sha256 cellar: :any,                 arm64_ventura: "10f6604d102628f201753001eed1ddfd9af8bde1df372685093e89e6c20e4645"
    sha256 cellar: :any,                 sonoma:        "8deb1d22c5d956dc388da567e802e05593e6d1773a928122fce8a8e99a621dca"
    sha256 cellar: :any,                 ventura:       "4c24767dd2ed95cdcecd0804cde500c6d65e5ffff0d45febbdb1f0befd9cbeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a629ea6c71d3e0187691a31858b32af1adc388d79825222ac4b26b67794c2f"
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
    # https:crates.iocratesopenssl#manual-configuration
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
      shell_output("#{bin}code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert check_binary_linkage(bin"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end