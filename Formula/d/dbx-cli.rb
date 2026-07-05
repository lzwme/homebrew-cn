class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.21.tgz"
  sha256 "04931b1befa82c0108f3085430071186b625730d5cae29a9385af4c4caf7e16d"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "85d2b5ce98027f22683e362121bbc2d3b601e48e67cc94a46dc4a0d152a38f0d"
    sha256               arm64_sequoia: "215a2b32cf563b0a666d86d6049531619f98a9900363e54fd8e0d2c1408a1f9f"
    sha256               arm64_sonoma:  "9d16c6ac7acf01f2a101a6c6a9a4c4a57b1a1264770480625fbe54487544450f"
    sha256               sonoma:        "cb5f0516d49ada16e1a5f3ccabda9240ca631ceb6213632cea85f6f2e35ba597"
    sha256 cellar: :any, arm64_linux:   "2a209f6cab2bcce0fe60a06eab8d5aefd2abfb10e2d5c783b8f3a9837d649cbf"
    sha256 cellar: :any, x86_64_linux:  "5b5fd501084b13cfb01dc7017a6e207513f8c476c68243f6013aa174f204f2c3"
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