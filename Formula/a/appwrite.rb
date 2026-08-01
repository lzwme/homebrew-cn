class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-24.1.0.tgz"
  sha256 "6a2074a53f76f4224e6020137339605c4afe39e911d0a8210b55fd40b3ef0cd4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7e973ee7aedf9960eedd167cb7d0259b044411c697742c5f0c3d1dfb2955494"
    sha256 cellar: :any,                 arm64_sequoia: "a7e973ee7aedf9960eedd167cb7d0259b044411c697742c5f0c3d1dfb2955494"
    sha256 cellar: :any,                 arm64_sonoma:  "a7e973ee7aedf9960eedd167cb7d0259b044411c697742c5f0c3d1dfb2955494"
    sha256 cellar: :any,                 sonoma:        "c0b4d2f2227ee1f4a0cee47e5a2736b81f53edbff92e7a43d7032e4c5a0f8bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69a3d6913ed07fa97f58f43e5dc55c3c883d1ddd12546c6a5f87c1a649168c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf04349cd80a6ea91bc76a949c2de74bee1049159fd30dcd32e5aa1947895b9"
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