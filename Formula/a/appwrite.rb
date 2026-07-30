class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-23.2.0.tgz"
  sha256 "9416d01aa7bbcd3c686229540ce1f842067cba9696fcafdfb13a5492ca7773b8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98b104ae00094cdf3b0948230a09871b194b5bde33fb7454f6f8ac383d8caa93"
    sha256 cellar: :any,                 arm64_sequoia: "98b104ae00094cdf3b0948230a09871b194b5bde33fb7454f6f8ac383d8caa93"
    sha256 cellar: :any,                 arm64_sonoma:  "98b104ae00094cdf3b0948230a09871b194b5bde33fb7454f6f8ac383d8caa93"
    sha256 cellar: :any,                 sonoma:        "58cbf18d7b255dd21f3250363ed4f1bde66a24717c17f64052f89bbf46e49a9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a588e851ca649a47b4e4e7b72f7296835c2f637c01c32d5c8fcaa1afa1f2176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c244655970afe226f26de3c570819ea7a8157bfc04f9d46adfbe1fc287f596"
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