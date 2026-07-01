class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.17.tgz"
  sha256 "1a7346460c00bb4020a5feff789cf3cda9498a2b3edc352e069cf1ff2be25c09"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "bb89994a4ed4427fad314542102fc443afc7952f70114a0487d65c252ef7a4f9"
    sha256               arm64_sequoia: "85dd36aa3c65d0d73629585ec9deedf18b4d9b2caf49b141368b9581a14b225f"
    sha256               arm64_sonoma:  "baaebea9552c30807d800bec48688506a4fb840118d1fcfcb5ca749651d0f9b5"
    sha256               sonoma:        "324d8a8868566ede82f7ee8cd1616675d9d78889ef7d6d6243959e7c8ab12990"
    sha256 cellar: :any, arm64_linux:   "1e51b9b0601c35946839ef15d2d46aa1d77715aa7e7fdfaafed061c8b982654c"
    sha256 cellar: :any, x86_64_linux:  "b98131f50970cb0f0cd60162b2b36a02780283f4d85f6f307b96b33add16cf80"
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