class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-24.0.0.tgz"
  sha256 "019b4b70bbe1b3410ff8ab6c7ce457582cb3b76b3c32c0363411137f076b8f95"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c67255a8576661ed0715092a8b8f7f2d69ba57a3843852995d9672b077bec0d"
    sha256 cellar: :any,                 arm64_sequoia: "5c67255a8576661ed0715092a8b8f7f2d69ba57a3843852995d9672b077bec0d"
    sha256 cellar: :any,                 arm64_sonoma:  "5c67255a8576661ed0715092a8b8f7f2d69ba57a3843852995d9672b077bec0d"
    sha256 cellar: :any,                 sonoma:        "bd620c9578e3cb7de6e93d225f143b1ba9bdbd3796b389378e24d86d673146db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ffaf238545ab2d47a14f336ac87619faf0a89239e37b1d0695240d6613c94b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "180126750428491bd6de819f8a98112186237d49662ce2db89a9ce009c2b35d8"
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