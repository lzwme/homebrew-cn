class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.9.tgz"
  sha256 "aeec9c89bba9a41c744f12454e1fc80989497e4d28e7775a039be7e8d519c7f8"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "ae7a4534a29722a5001442b30eb907f37aac290fc94e8b0be0ec8187605cec39"
    sha256               arm64_sequoia: "8a50c353b7a3447ac7369e63de304bf8ba669fd769eeb67343b1e3b4fe3276f0"
    sha256               arm64_sonoma:  "79d7b72bfbc592ce7a0bfee36e42675b016d457d0140bccd888f2c864989bba5"
    sha256               sonoma:        "e1a9cacfbe2e51b4c3627d2a78bb00ce71decbf3bc24211606f797eeacaa2f8e"
    sha256 cellar: :any, arm64_linux:   "5b0737f7af0120e6505eb07ad51789f0d13b36c114c7fc6e43854a845052c4d6"
    sha256 cellar: :any, x86_64_linux:  "2901f8fd046b0f1ef62d062d9952ef8dac66357c978276d905e5dc0e6a6cce02"
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