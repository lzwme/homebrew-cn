class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.18.tgz"
  sha256 "aac84503654652aa508ff7de63832aef65381075dd5d1c535021f8a9c57101ee"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "6826db6419467d63fd4ca7333cd5ecb1811dda0d77513f8d731fa706068369f2"
    sha256               arm64_sequoia: "70c9be60519363ab11ae180b4c74dffe2a3440647a42dd16fbd7ea89135970ea"
    sha256               arm64_sonoma:  "3f0f17dd87bbdeffac6e76f416b04509ce9267ad6049e3dff22768a2d21b95a1"
    sha256               sonoma:        "3abc60fca7fc29214b0a46aa42c784f1275996bd79962bbe957374d611f6a2e0"
    sha256 cellar: :any, arm64_linux:   "55265f99ce969f2d57735b98f4ed9b91c3b2202392f9ddfb451395558b4efcaa"
    sha256 cellar: :any, x86_64_linux:  "13c072f8b80c75f9c51c1d90872eaff3ffddee8db911577449a9f1737c9f5c5e"
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