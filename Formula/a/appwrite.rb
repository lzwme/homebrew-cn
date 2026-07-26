class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-23.1.0.tgz"
  sha256 "431f01dd2b340cab420bf5ea865c431536c23d5f8fc54a6f8c521825733eb1e2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6352dcce89e0f0125b7d230a56a8e31bf8c54aa9a021b66a56f713ca2f396088"
    sha256 cellar: :any,                 arm64_sequoia: "6352dcce89e0f0125b7d230a56a8e31bf8c54aa9a021b66a56f713ca2f396088"
    sha256 cellar: :any,                 arm64_sonoma:  "6352dcce89e0f0125b7d230a56a8e31bf8c54aa9a021b66a56f713ca2f396088"
    sha256 cellar: :any,                 sonoma:        "f0ad0d302805bbc8907e9a988ad594060c4a893fbda2d47c1ef681d5dedd40b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9de0a66c57896c2f20904b9f6d320c0cb7bb65c3a0a4331441d9c73b2df80a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d02795884bed4ffcedca9941c460445e3af43f99dd00ed4e7ec148101e8f23e4"
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