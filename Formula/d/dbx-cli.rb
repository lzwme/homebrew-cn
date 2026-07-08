class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.22.tgz"
  sha256 "36a48da22b86c4df4ec6d788a49905d1768fa6f100a93337b48e5d4a4af16f19"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "df07e1ac39082cd4b5162f90e504276ea23bd869c1c4a911a22c0e98a7ab4954"
    sha256               arm64_sequoia: "aee83ff02654ea5607331743835902a789885cb7ac365d98d4d432e95f69265f"
    sha256               arm64_sonoma:  "ebbd8f13b35fb6cf462028bd90dc2349071eafddad8c51ceb78308bf13d081db"
    sha256               sonoma:        "eaf895465f7c7c4b210929f8043ccd435b2455b1bdaee1bab7a54214f91242bb"
    sha256 cellar: :any, arm64_linux:   "dcd4169247cf078fe025cc8366b2c765f44b9195e35fa10f759cae1b5f68e17d"
    sha256 cellar: :any, x86_64_linux:  "040b40e1d26661431b8a3b03f36de390c1367deedec5fa6e2500724635118a8d"
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