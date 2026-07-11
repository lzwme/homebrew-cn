class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.24.tgz"
  sha256 "b837fd8b5748cc8049f6bd91399a242ec4a6e6be317f852741b8ed1da5b62a0a"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "3ca17f26abd2ee6b5d0ea19af802a71a2c9325b975306b7d182c0357c72b0dda"
    sha256               arm64_sequoia: "61475583f4d84c86299fd7ddde041507106833fe2015d329ad5947c09e21d229"
    sha256               arm64_sonoma:  "da092bdce73469405f64a93ed64880484785b56cc870908d0d590d0877bc12c7"
    sha256               sonoma:        "2fb34db3f02ccc1ec0ea0fec4b5bea6fee4fe4f4a45cc7101e11d370f7b406e2"
    sha256 cellar: :any, arm64_linux:   "4ef116abb85820e3984d706e98ef77be22aa6185686b15d83ea7f54e81801535"
    sha256 cellar: :any, x86_64_linux:  "f1befdedb3ffe6fa89c4cf84ae317e775bbf29c47b1063fa8883a9c172eaa219"
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