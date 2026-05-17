class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-21.0.0.tgz"
  sha256 "863f7f768f0a137503e164f6bfcfd9329ac041272d825d60cfb5944c58e41d74"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a29a6585de5526f71bffbe5792b8d0c8ba86b5078d6b5a8990b564d541a7718a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07f3fb295e914dabd47e6dae1b20454a27090641546b3eca206acbc4b48afcc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07f3fb295e914dabd47e6dae1b20454a27090641546b3eca206acbc4b48afcc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "26856c3418711b8769406cc30ffaf2fa83fd6e3158f13f550bce63a5c654be9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e564a0806d6e8afdd492089ffb16bfd617f56dc8e7cfeb58af3dacd64d13e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e564a0806d6e8afdd492089ffb16bfd617f56dc8e7cfeb58af3dacd64d13e61"
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