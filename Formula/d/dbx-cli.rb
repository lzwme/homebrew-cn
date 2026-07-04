class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.20.tgz"
  sha256 "cba1bf38c8ac0d6daf02cbe643714964a7c44950c0cd0710c367cd73884bf779"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "ac69e986288621cd13e7314fd889be1fa1f0e1cb648d1f63475e040d96f48f53"
    sha256               arm64_sequoia: "c2b59e5fdef4311baf319adc428ed9a6d818fe0c0aceec261256e8ba35445e93"
    sha256               arm64_sonoma:  "d7aa45f6b04bd71c5d9734f042c3a64b9aca483559dc64f542e8ccb0eed5ea90"
    sha256               sonoma:        "3a1ab8d9a827dac19b0dcb76f9af02b88537702fcb525e1152e008c2cb97c928"
    sha256 cellar: :any, arm64_linux:   "da196f0fc5489ea0051640d1f598900fd07826deefc2df2a0ac2cb9d2ecffe3f"
    sha256 cellar: :any, x86_64_linux:  "2200bb68a240ffe7b0083553218346de47831b74fff5b2597ab9d72dc6cafb37"
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