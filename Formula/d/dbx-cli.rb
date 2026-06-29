class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.16.tgz"
  sha256 "c54faf38d032bde7d8be81e779870910901805af96351feb58b13cfd367e75f1"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "41e8309bb0a02c6c0c0fba20859fe5fcbe38b3521d392fd91f2bf763d792ab53"
    sha256               arm64_sequoia: "b4095a926a3f2adb2d5fa8938892e0cd39c19419ce66870a73a4b28e11519b6c"
    sha256               arm64_sonoma:  "a6ebd40962f3a54a7b322f165c9ab0057036260967db7a53e6740d196435a350"
    sha256               sonoma:        "610fef273b91d3f66357df7ae3781629f879058a10ed6e738975a0b25c2df3bd"
    sha256 cellar: :any, arm64_linux:   "ec1d91922c7b69944cda0c9f5a4aaf6e873f26546e9f6c9b4a3aa67c15e09488"
    sha256 cellar: :any, x86_64_linux:  "9eca9efbb84ac4d060e2b4850bde8ee41c3a7339c0bb1e4d80ce76f17e5d45ac"
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