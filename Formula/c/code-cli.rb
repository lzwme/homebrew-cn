class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.95.3.tar.gz"
  sha256 "46f9229de5c5be460168b16a47fe73936f4e1ee4d53c31d2ac5e0789c63d1522"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab5c94fbad0831db492ac8cb53702b1a9a440991a5efbc3623f66aab5e3317fd"
    sha256 cellar: :any,                 arm64_sonoma:  "08c041e0b4c7d613e45053821357423c6a5abdb4288ca6e7d839efe6ec4c2902"
    sha256 cellar: :any,                 arm64_ventura: "0e9eaeec7021bb549810bea2b697d29ab595fd062ede835a7c2234c918095870"
    sha256 cellar: :any,                 sonoma:        "3fdfbe846a1ae32015fb6d9b66547f174b8cc809333bb51cb06ae2314833df31"
    sha256 cellar: :any,                 ventura:       "4ca12d4634f36c1ec16ddc76d39ff49535a85911216513d2498a0879e92062c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef3ef68e10ecf2b19252058b9de0c11d6421a547dd6f4021b79e4d0fbcd03913"
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