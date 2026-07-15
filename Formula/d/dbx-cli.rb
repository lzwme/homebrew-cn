class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.29.tgz"
  sha256 "ad85ab43b06914506ee97f59740c42efafbe1ff951521eed039e5c2df537bceb"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "4f60015c510e2bc1a562c0ade4252b1f0b37291e1fce5a2212dbb18247803f5a"
    sha256               arm64_sequoia: "1e5f52fe14888dd342a7db26b96dcd4d93379165330604629fee7def463cfc4a"
    sha256               arm64_sonoma:  "ea63fd7e8f85e489c1d567c5effc926f9955d32215c68457386ee0131c9d2947"
    sha256               sonoma:        "9b84448fcb602d60c738ed0eeaea1995d975721a4ab23a2f1e5f71a74bdb42ec"
    sha256 cellar: :any, arm64_linux:   "422f05a3292dcd2153c8f5708364fcedeea7043def36d70b2474c03b98c239bb"
    sha256 cellar: :any, x86_64_linux:  "e48452a1affdd583c5d911f696e4e26b3566b3d8704e979c46804e3ef307169c"
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