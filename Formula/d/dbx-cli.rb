class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.27.tgz"
  sha256 "1ad1cdb9730091bac59c58fde68108024706cbeeb0d31c0ef4226b2fb5988fa2"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "019fa184f08624db4115b9261f671237aa90a16b7abada9d81e0edaad4bf8ceb"
    sha256               arm64_sequoia: "8bc31ed321c3949308889c7aac7378bea99136d39a5f6be7b6c5ddc489518a05"
    sha256               arm64_sonoma:  "ebd3697ba6251a8ad9dafd08c53617c7063921d81e0069fd8107dda461040699"
    sha256               sonoma:        "b147339b46267a771a5a000170bb8b28caaf8fff3da61386c41e521d78661d05"
    sha256 cellar: :any, arm64_linux:   "268b4b024662c0213c0faf02611ba50e70bca33f55b664b49f37472964340b2a"
    sha256 cellar: :any, x86_64_linux:  "d4999f0fd7d1b59e984f89f0f3344acac6847a209c0baeb899d8df10f8f44075"
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