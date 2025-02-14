class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.97.2.tar.gz"
  sha256 "6bbb7144e11fefe06418c1f3671a877794a7513c2add85121f560dc686c31351"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0173bdcfc9b6ee59defa798900d65989a40b6758a17eca6d00b0fafd48b42e6d"
    sha256 cellar: :any,                 arm64_sonoma:  "4821ca30fcf66157c39712999adea51adf8c67eaf32be6122ce779d817fd93cd"
    sha256 cellar: :any,                 arm64_ventura: "879cfc3c1c8c9e059298b0d68b1beeb3051a6a76ceb8d0d988197a8cee0de2ca"
    sha256 cellar: :any,                 sonoma:        "4c7b7f52ae31900ad0f895a6535d9f8879cc32a1c7de93d4571a366feab22b2f"
    sha256 cellar: :any,                 ventura:       "10dbf1abbf7d558c110dc5a3db73a331a95509c11dcd67debf0afa704659efed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d88660c54a78b941da884d674f3ef288a85b58d5d8a8f52ec3ed1a3bd3f6319"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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

  test do
    require "utilslinkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end