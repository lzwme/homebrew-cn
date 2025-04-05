class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.99.0.tar.gz"
  sha256 "370a38319a2acd3d1c2faae95637e7e940b65dd891b618e9c588501d7ed46190"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af7aa1f188c1ae05e91c6a4023695bbb56d0589b90deeeb5fbdec129c3152b0d"
    sha256 cellar: :any,                 arm64_sonoma:  "b98567ca1c9e4bde573ff8ed8162fa07cf9bc13e66de78b953251561ddb46dfa"
    sha256 cellar: :any,                 arm64_ventura: "322101e91af346c5a585389569e92f1f3224494e29c27ef760c836c5cd3d117f"
    sha256 cellar: :any,                 sonoma:        "64eb39aaee14fe68fe2b9ae58fe01efb5832a7fd18908bdfbd95fc44c96e9135"
    sha256 cellar: :any,                 ventura:       "a9dfc274b5937fb7732140fbea54e72ed9d7fff8a607d316412c8ce07ec6836e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c6ba708faa3132a6217c8e6f783c5cf46ddd571bfc140bc3a476d097a006d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95c5ecbd04d73bbed51edc594f1284bfd82bec6448dbbc0be771ccc99b755911"
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