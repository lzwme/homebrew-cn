class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.88.6.tgz"
  sha256 "60f10dc8fd8823e2f87cde0384b82ede058e4a3285a6fe33ac4fa2467fbe01a6"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "957d50e94a809016896d8052d10f504332814aa5ea62724bb88de5bf2fc742dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "957d50e94a809016896d8052d10f504332814aa5ea62724bb88de5bf2fc742dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "957d50e94a809016896d8052d10f504332814aa5ea62724bb88de5bf2fc742dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c25ff335ff540a95622f09df39f0925a0c06287970c23e2782f8b51183ef3fd8"
    sha256 cellar: :any_skip_relocation, ventura:       "c25ff335ff540a95622f09df39f0925a0c06287970c23e2782f8b51183ef3fd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "957d50e94a809016896d8052d10f504332814aa5ea62724bb88de5bf2fc742dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "957d50e94a809016896d8052d10f504332814aa5ea62724bb88de5bf2fc742dc"
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