class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.11.tgz"
  sha256 "ef704cda14c2199f4c8b8e44ef4e86217f6784356715ea77bc2de4431b3750fc"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "1488c2714ac30f54e0d23a1dbb1fe272a312309696a256a90a46ba4ec0508b92"
    sha256               arm64_sequoia: "ca9a5b38886d4d09e76ad5cab9dbfd1ba6bdd0ae125ff21f1f6ff2352dce8c3e"
    sha256               arm64_sonoma:  "1bef04d772c8e8175b455f1dac639254cc0500e85c677f7ebdb127c20efb8de2"
    sha256               sonoma:        "6e98f0de466463fd4b6b9df0d27de0f8eb6900b0dfe0c60bb300238e15884a38"
    sha256 cellar: :any, arm64_linux:   "2d1ef32a6f25c1403a8c05981ee8c911f05df22f17cf2162d29a3db95a57c743"
    sha256 cellar: :any, x86_64_linux:  "a97dbe61fe40109278c25ce783197cb4ac492f6ea27414db6a93ea9b95b4cb4e"
  end

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Rebuild better-sqlite3 and keytar native bindings for the current platform.
    # prebuild-install is blocked by the Homebrew sandbox during npm install,
    # so we must rebuild them explicitly via node-gyp.
    node_modules = libexec/"lib/node_modules/@dbx-app/cli/node_modules"

    cd node_modules/"better-sqlite3" do
      system "npm", "run", "build-release"
    end

    cd node_modules/"keytar" do
      rm_r "prebuilds" if File.directory?("prebuilds")
      system "npm", "run", "build"
    end
  end

  test do
    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end