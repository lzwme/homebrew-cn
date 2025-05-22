class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.89.8.tgz"
  sha256 "d01627ef5b5079141e2e1ac15d76481a6b167f6730d51397652a091ddc5a2845"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76939b1e949fe50a4dbcb4285a6d06490f97957ff50d2c8ea2a589aaea70c6ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76939b1e949fe50a4dbcb4285a6d06490f97957ff50d2c8ea2a589aaea70c6ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76939b1e949fe50a4dbcb4285a6d06490f97957ff50d2c8ea2a589aaea70c6ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "927c51709c69d2d6f5213f39849c5a44e828314136209ad4a55436d179a2b76f"
    sha256 cellar: :any_skip_relocation, ventura:       "927c51709c69d2d6f5213f39849c5a44e828314136209ad4a55436d179a2b76f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76939b1e949fe50a4dbcb4285a6d06490f97957ff50d2c8ea2a589aaea70c6ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76939b1e949fe50a4dbcb4285a6d06490f97957ff50d2c8ea2a589aaea70c6ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"sf", "project", "generate", "-n", "projectname", "-t", "empty"
    assert_path_exists testpath/"projectname"
    assert_path_exists testpath/"projectname/config/project-scratch-def.json"
    assert_path_exists testpath/"projectname/README.md"
    assert_path_exists testpath/"projectname/sfdx-project.json"
    assert_path_exists testpath/"projectname/.forceignore"
  end
end