class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.13.tgz"
  sha256 "560463b886ac613f16f5a8b15869e02fcec251b883429934ecd4b02c798c50a9"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "089125b6ebbdd8724608a6d861c111fd49b95e6710ac842b13797805a4fabace"
    sha256               arm64_sequoia: "ecac0f0c8d9c22e48f07088031843ffb852cfd3333956758fa1839d37562dfcc"
    sha256               arm64_sonoma:  "c4f9d03db4f3d1e42583a0219595332a8279933ce643b249429a75e683f12c79"
    sha256               sonoma:        "a4955d07744e6892da19a32fe44dc9c63e54ad52f511abcc43aa7b507182bd59"
    sha256 cellar: :any, arm64_linux:   "839474ebad70a6e45efa61285c6efc3751d3c175ca733fc8a61fe65bc602098e"
    sha256 cellar: :any, x86_64_linux:  "7391442631ed907bf822745b557941af53f64be484702995906014a449ce4027"
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