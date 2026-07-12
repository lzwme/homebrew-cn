class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.25.tgz"
  sha256 "bcb4aa9b52dd655dd7e6e9f03f4e571a637fc613bea806314f52aed7a9a7af40"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "955d3936c4f6e0517a4c26de50a0ef2175356ff019d33ed9808b7859cc0774d2"
    sha256               arm64_sequoia: "cac8a044a5642d132e38f859aba72eb69ff66f8c5d6027836f6dc0edf2bc44a3"
    sha256               arm64_sonoma:  "2cf84ac9351cc2947d74fe846756e9c672bbfd6084075439a9f5ec1168917c3b"
    sha256               sonoma:        "9b6b01fe2b3b2fa3680f636115be516ab163a6a64b05abf3b463cdec5801d252"
    sha256 cellar: :any, arm64_linux:   "7e1dc8df210db6aa4fcb67b298399e91ebac1f49c215764c9e3ad7b0713917f8"
    sha256 cellar: :any, x86_64_linux:  "3a7fdd375e6fe8ba7351a7ec7e29fe917d00d7e1118b69d4c4efd1331ee9fa5f"
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