class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.12.tgz"
  sha256 "36a3689617e60c524cfe06036f088fefc60e85da50458eed37c14242496adc9f"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "0f4aa85401e027eb1813614f9de869aeea4677b8b5a78afc7db6b841f53d1d75"
    sha256               arm64_sequoia: "546d48d5737981f0b9c133248205a6e19f4e6e5294821d306e1553eb96a19869"
    sha256               arm64_sonoma:  "ded77db1c2ed9c5402337e5dc8369b5e308879ecc00d574a0bd7fd48d5f9247d"
    sha256               sonoma:        "87bc39d4b1ba5629cbd64017f97b446d7f8f8210a661075b0e5cceaeb62d3bed"
    sha256 cellar: :any, arm64_linux:   "4ea8ca5e9a1fe8be1b5ee034b3c28a33f88d7e5cd9967f34558f2cce6ca8a71b"
    sha256 cellar: :any, x86_64_linux:  "6d432576cbc4c12c4376dcc87152f4820a1ac3627a1fb1e6aeac584700cdd37c"
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