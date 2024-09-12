class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.93.0.tar.gz"
  sha256 "4966f7f2b189e6621234e31bd9a1fd141b8269c584cb8d0cf3e3d99b5119c2ab"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "935aa68e8ff7b354e35e61a775f9c6dd41b3be4847e56d7a56dd2e8300049f3e"
    sha256 cellar: :any,                 arm64_sonoma:   "42a7dc1bebb00d79c034a9e31e7df6b23e963043cdd1a466d00c47de78136b6e"
    sha256 cellar: :any,                 arm64_ventura:  "c29ec4e6865a970d5de489af062bd61d9e5f466f9399fd3b1ddeb97dc4486016"
    sha256 cellar: :any,                 arm64_monterey: "35d892e4b5b9bc75315e825afc62e07e32dcd2a0e43d7f101d5e12b9ac2ea1cd"
    sha256 cellar: :any,                 sonoma:         "0bee95c6fbea97c0c5a74ce944c60fe0e8aab66aaedf84b87d800ff78b2b7f9f"
    sha256 cellar: :any,                 ventura:        "2a78730a7ac3e2cbfcf2fd2d7edbaa554f307e5662f8e0d41c1e22af6edf0eb6"
    sha256 cellar: :any,                 monterey:       "d64e75d0035b786d3e53d5b194ccd64f21c7d2b42d284f25b289c74a0c26c68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bca238a88906d9fc68978f48a239eeb8da89c75a4584a83cc563247614155b5"
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