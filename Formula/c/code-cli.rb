class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.91.1.tar.gz"
  sha256 "d2ed726dd34d2e8e71d40b09c0ea648bf9b37b15982b39dddcb70d0cbfcdb45e"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c62e6d3d1b1066a791663c9c6d5460fcce7bb4824afb3065911456240fcb9580"
    sha256 cellar: :any,                 arm64_ventura:  "026b9593b24da751c678a7294cb6039d5fcaae6f3d7193d07a600576b0892dd5"
    sha256 cellar: :any,                 arm64_monterey: "1c6b4ca17ac3d1c7f8e26e2ac3cb613975c914ef322a09097f0b9b3d7ccc1ca5"
    sha256 cellar: :any,                 sonoma:         "48c71e19436ba83757941fb0c70f381c899904d419b4f0ebe18571e95e43670e"
    sha256 cellar: :any,                 ventura:        "2449ca8ed42826b755601e31c30901c98c7087cf58b39a02fd988ebb839ea3e3"
    sha256 cellar: :any,                 monterey:       "b0be3477929ac9c7345fc5b200e1a00712fda4a2f87b3bcf41b5257bcfe24a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bac86d757c9b50f1e3adf24e9eac25a71c4ab4763a6a6a6a151be0b4c81d083"
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