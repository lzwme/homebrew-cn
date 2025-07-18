class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.9.tgz"
  sha256 "e0d461ea81b519d6ce43bbd4f4a15a5efcde22d793e607329957cef759f15b4c"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c999d3036f54eda5b753f86fc5e43ecea275982b44a58b4cd86443d5c092186f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c999d3036f54eda5b753f86fc5e43ecea275982b44a58b4cd86443d5c092186f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c999d3036f54eda5b753f86fc5e43ecea275982b44a58b4cd86443d5c092186f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d5cf7b00015b1e67d9ae7615a2ead1682ece9b4f18ef50db8125bdf64de3f74"
    sha256 cellar: :any_skip_relocation, ventura:       "7d5cf7b00015b1e67d9ae7615a2ead1682ece9b4f18ef50db8125bdf64de3f74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c7c2a860806bc3aa3b27f751a0f50e914c65964eef40a536925e0160f34339c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7c2a860806bc3aa3b27f751a0f50e914c65964eef40a536925e0160f34339c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end