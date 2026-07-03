class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.19.tgz"
  sha256 "2e0d16e533771edd77ea398dd720daa46fda3dab4ea550ba4f1f83fdcea96e70"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "ccf6716bce3bcc1197c8be91e31d83f0b6760701b2315cf577e12ac086804b0f"
    sha256               arm64_sequoia: "072552d7d05367699a69d5fea73ec9e837c60e084cd69b4922572bc825014cfc"
    sha256               arm64_sonoma:  "aba18451b87a489fb69ca96c3a49cf1ef0e2f9528139692fbc2068d91d443a85"
    sha256               sonoma:        "179e6289c672689aa9d9665948548b1c73b7403f588273a26522771a1c23c838"
    sha256 cellar: :any, arm64_linux:   "68dbb2c84a8def55e9a6f9e7a02128381164ac54b8d6b67c1bd5e44b352ac331"
    sha256 cellar: :any, x86_64_linux:  "22e6c296eb5773c60adc2dd3378bf017f8c31de7b953e806e11f1becb9cdb919"
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