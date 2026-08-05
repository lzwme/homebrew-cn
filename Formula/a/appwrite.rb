class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-25.1.0.tgz"
  sha256 "8305396001127824ee21cb3b4922ef5c17f3fefdc2e7807fbf50b751c5c4bc43"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e6a080f2039f7368addad1644b13adfebf4c60d070e712bf645fe49d585b269f"
    sha256 cellar: :any,                 arm64_sequoia: "e6a080f2039f7368addad1644b13adfebf4c60d070e712bf645fe49d585b269f"
    sha256 cellar: :any,                 arm64_sonoma:  "e6a080f2039f7368addad1644b13adfebf4c60d070e712bf645fe49d585b269f"
    sha256 cellar: :any,                 sonoma:        "5875c3a1a5b214313fb5466da43f811f808c997b81310bf4d5ffa6aa9423b96c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36df56f77d98777a954d45d711ddb03b186c0cfdb8a2fa7fa1a499b85aa938e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9e081906aae790a453a2ba2f275c372dc5f44109165f1e8e3cdcb1cc2b0c8d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end