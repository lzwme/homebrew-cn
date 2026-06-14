class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://github.com/t8y2/dbx"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.8.tgz"
  sha256 "df8a2c6dc213f4e137dc451eb92a825d0c33fb8da22f5b4de6aec54105a159c5"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "de966e670a51045e03746fb8f9952acd3d67269e112bdc13c140e436be29e688"
    sha256               arm64_sequoia: "99874b6b2988df664cd77245adc1cb2c8a959254188b62eb5a7790c4addc16f1"
    sha256               arm64_sonoma:  "11bb165a4314fd824988adf6cbae96ebe2a3364f208788c48d1b9ad0858a49c6"
    sha256               sonoma:        "aadc72fb43773ea145e0cbf3123f9c02815fb31ffffff9e2579ed715560491a7"
    sha256 cellar: :any, arm64_linux:   "7bc1142e06a5ede263a2197e419c6e9fc08fec74cc47fc579e0739d06e32ecef"
    sha256 cellar: :any, x86_64_linux:  "9d38fc531e4b9b9f43489ca6123a3c8618dc1c3cd087428267d5060b4cfc22da"
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