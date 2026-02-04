class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.2.0.tgz"
  sha256 "984e4cdb8917487753a34cb58702c3a14c9c672927351674feb989eef146d0d0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50cb747ec81a0b8960e8e546dd5b97e0f32b2d62e3680923c3d4641f06b0ed50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "504ea86037fe0733080aa0a8ae5a5b014bebe95eaae30bd43e1d6e6e8fa7adcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "504ea86037fe0733080aa0a8ae5a5b014bebe95eaae30bd43e1d6e6e8fa7adcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "62372021bc346f3179032aba38628b438bcde9cde2d675813606f952c059ad73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5ffc5526ddcb72beaff4b91fda4b499da403d58432d92bad20f3446cee5d55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5ffc5526ddcb72beaff4b91fda4b499da403d58432d92bad20f3446cee5d55a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end