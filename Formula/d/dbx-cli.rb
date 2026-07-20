class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.34.tgz"
  sha256 "0a7260f9f880bac95cba476da9e79e08efac10728536059bd6253c9692a8baa6"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "58070b0f57511d444262d478895dde9cd44eab06d984a4cb4a43b852e4665559"
    sha256               arm64_sequoia: "c128a006825a31d8a953d92a62feb4b2eeed0c7fdc678a2d31f3c8a11e0067fc"
    sha256               arm64_sonoma:  "407eb1932ac183caf15718726391eceee924057c31eb7107c3545fe305868f0c"
    sha256               sonoma:        "9ee5f23a73d818c17171c34c0289a37ca4a58a8b1cf52e138c1814b8ea10de73"
    sha256 cellar: :any, arm64_linux:   "ce6530f7536d632e576d80e99ae5293b74943c202903e1d4e0906ff716b68309"
    sha256 cellar: :any, x86_64_linux:  "d95b6eb6b46fb84649e15c66e594f795edd341b05a25f7a1b8a4eae675fe4c1c"
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