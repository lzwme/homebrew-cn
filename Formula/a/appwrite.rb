class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.1.3.tgz"
  sha256 "837813febb94becf716e699ee1a481daf75dc356e7336e41a98d5de1f1288326"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "767a31d491fa9453a3ecce0d7473feaf24c13c90dfcd899e92d3c2bdd3228bb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a442b74e2dde5f52054ce2a04b961eff609bba2c44ddf1ab9ed6f633d325df64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a442b74e2dde5f52054ce2a04b961eff609bba2c44ddf1ab9ed6f633d325df64"
    sha256 cellar: :any_skip_relocation, sonoma:        "00e6e3bd8e60af8effe8f18dea5b2ed9a75152b92fe957e5e2b197b8efac060d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2109ee94a813a38360482871bb2f8baa3ff7ba89f12651fe4a171eb7abd2c4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2109ee94a813a38360482871bb2f8baa3ff7ba89f12651fe4a171eb7abd2c4cf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end