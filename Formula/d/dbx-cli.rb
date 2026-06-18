class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.10.tgz"
  sha256 "bad1b207f4b77f18f18235a55df993edd0bd2c65f136f5765a62db813c3c0b31"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "23c5349757dc717fec1f2a2fc453d183fccdfd42da8622708a0949505b871c69"
    sha256               arm64_sequoia: "53fc9edd15999f56293c7d18cac654896916ec47f24b1fc8007d867ba7cd6737"
    sha256               arm64_sonoma:  "7e1fcf688038b683172ba5b93beebacdbb48f19874d759644a06d149fe66b3aa"
    sha256               sonoma:        "c39900053481102aa4c2d127f39d3e7ed6d815acbcb707fcd4eaf268115d3e69"
    sha256 cellar: :any, arm64_linux:   "06e7b3a46c35b8b91c92d20bebfd2005c142b3724426cb9aaa83e076de8c1b10"
    sha256 cellar: :any, x86_64_linux:  "eb054492d2ef8723eebf1812935e6da1b9b067b041a689498813841ec237a8ce"
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