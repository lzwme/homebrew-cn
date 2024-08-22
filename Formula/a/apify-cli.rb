class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.4.tgz"
  sha256 "265dea78c47ebb931886009b85f974c8f9ca383fd0b5ca034bbcbefe8b89588e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "263598893593e3be88f63efbbc9d71215418b13b44888b39c2e16fceed3991bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "263598893593e3be88f63efbbc9d71215418b13b44888b39c2e16fceed3991bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "263598893593e3be88f63efbbc9d71215418b13b44888b39c2e16fceed3991bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "144587d5e14c9624e9ca08bb1e1d5251dc6aa134a77093cfa302f483240e1a03"
    sha256 cellar: :any_skip_relocation, ventura:        "78a7b93f28dc0718a29b72728d319599a3f1917dfcc57ca0c61144cc82d3820d"
    sha256 cellar: :any_skip_relocation, monterey:       "78a7b93f28dc0718a29b72728d319599a3f1917dfcc57ca0c61144cc82d3820d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c406b4790a43e3335ba67ecb7766fb4f18842c5a028c8a1bbdb64d8a34979519"
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