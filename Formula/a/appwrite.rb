class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.6.1.tgz"
  sha256 "4b32dbbde88c278ca2300d53fdcc53832de2625dddda9a599e92ac8dceb50b73"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49eedf77ecefc3e7fb18b983ec2110837ca024be8449dc039fbf8c37b5df880e"
    sha256 cellar: :any,                 arm64_sequoia: "3c724a1f35b69ca6467f324f3e1d3f2dd5b546d9c779ea1534381a3cf0c65a32"
    sha256 cellar: :any,                 arm64_sonoma:  "3c724a1f35b69ca6467f324f3e1d3f2dd5b546d9c779ea1534381a3cf0c65a32"
    sha256 cellar: :any,                 sonoma:        "488ad9cb074908b8539dd23d867c8ce6d61d075143c6c9b0b9a8dc1a0c344b09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85cd5a63c5960975f30289637cc2eeab0995efb2ef465c58de4e086c7920d889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22cc3ef88b28f4867628e66f7d54f718278262c792b947f20839d4eb68accce6"
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