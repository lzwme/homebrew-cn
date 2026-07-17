class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.6.1.tgz"
  sha256 "4b32dbbde88c278ca2300d53fdcc53832de2625dddda9a599e92ac8dceb50b73"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "74456d69c33ffb64a962973b86fbe0d7ffd516fb14b50a0a839e25efd5b92baa"
    sha256 cellar: :any,                 arm64_sequoia: "74456d69c33ffb64a962973b86fbe0d7ffd516fb14b50a0a839e25efd5b92baa"
    sha256 cellar: :any,                 arm64_sonoma:  "74456d69c33ffb64a962973b86fbe0d7ffd516fb14b50a0a839e25efd5b92baa"
    sha256 cellar: :any,                 sonoma:        "1cab4d272eaab609f4bd9ed30faf251914162ad21bc59875b1787490b554757c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b78ba6574f59ae981603e315b543cfbf293648900734abfa38eacbef6433729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd4da5e16e28943d6b6c91b968aedb8bab0b1cb499db57bf5c776b7ccf26532"
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