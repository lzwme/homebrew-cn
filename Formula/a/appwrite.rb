class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.5.0.tgz"
  sha256 "12c94946262b3f95a613131bf4e0ce0eb3d8385ea59c78ec496796e9da150985"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41617113c661d2c80ea3c270ea1d0d37053f25060905b69c2062b452ed915230"
    sha256 cellar: :any,                 arm64_sequoia: "82ca9aabf5d8bfcc3ab45f927e7ce960add650eaafd98fa051b97d448672dbc2"
    sha256 cellar: :any,                 arm64_sonoma:  "82ca9aabf5d8bfcc3ab45f927e7ce960add650eaafd98fa051b97d448672dbc2"
    sha256 cellar: :any,                 sonoma:        "fa2de3e22fa4dcc6192460aa244efa1fdfbf579299687104d33933140c26e12b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebd5b3871aa8a1207a8e5513c63345ec78a0f02ab45baa2fb1ec59d10f86c9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84373b1a2eef6758abb4b250b8ee2d6b67430bf038f662b2236de8684a12aa4e"
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