class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.2.tgz"
  sha256 "dfe8bf7a168cf221ef85380b78c3b7b56c1b19b059f8ec4003f3e9c9c2bd6bb0"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e937e9d467b1d3b055c2b00593e4612c54c469a28f4dd4f8e999e0919e94b0b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e937e9d467b1d3b055c2b00593e4612c54c469a28f4dd4f8e999e0919e94b0b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e937e9d467b1d3b055c2b00593e4612c54c469a28f4dd4f8e999e0919e94b0b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "412ec2fac67bb901b3d66f1c2b4f5f983472410bf2b8717a0b68d8d1059687c3"
    sha256 cellar: :any_skip_relocation, ventura:        "412ec2fac67bb901b3d66f1c2b4f5f983472410bf2b8717a0b68d8d1059687c3"
    sha256 cellar: :any_skip_relocation, monterey:       "412ec2fac67bb901b3d66f1c2b4f5f983472410bf2b8717a0b68d8d1059687c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afea6964352ba306bbf32c79e177509dad9f15f7cd484795e963fbf2b5812546"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end