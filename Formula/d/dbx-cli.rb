class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.26.tgz"
  sha256 "0a220fa90ee22292f726d0eec6565c0a39d26ad92067ff1bd7c4fc3ee0af55f6"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "c6fc03d7899f01ab9d2ef0ecd29bcc19d93c9d9138b252610f222b25a8c518f3"
    sha256               arm64_sequoia: "a91023ae8729d9f134ff1e8d293521ada8f5035ba163e2990b6c9f86828a6e33"
    sha256               arm64_sonoma:  "7d5b4139595a5c4a020ba08f77aae64754f2c90d821719afb39df1f0121331a8"
    sha256               sonoma:        "2ddd030cefb17c1b6f2bc2213b94dc7c34a8dfeeab8727cb4a516cf17287b0b6"
    sha256 cellar: :any, arm64_linux:   "cc9c6a9375fd2a84ea174e1ed89e11c8e254b849ab26c82d46e753c8549373ab"
    sha256 cellar: :any, x86_64_linux:  "d69efe2772414d6ae8fb6047f75147cf4a4cd32e94f459cfcc43214ae41f8113"
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