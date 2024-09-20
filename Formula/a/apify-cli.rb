class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.8.tgz"
  sha256 "83a96afcf7134ecadfc59d0fb1ebecb17abd904092c029c00f842d9ce7dd33e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bce6d953d8ccdd52c8e6dd6d9d44a6d7f558eff5d122fb0a812265038258ce89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bce6d953d8ccdd52c8e6dd6d9d44a6d7f558eff5d122fb0a812265038258ce89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bce6d953d8ccdd52c8e6dd6d9d44a6d7f558eff5d122fb0a812265038258ce89"
    sha256 cellar: :any_skip_relocation, sonoma:        "25016a4a0cea4a2fbbb391565d12104399bfb23bd4532dc76d3ad36818fb47ee"
    sha256 cellar: :any_skip_relocation, ventura:       "25016a4a0cea4a2fbbb391565d12104399bfb23bd4532dc76d3ad36818fb47ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c33d3e1054c5f4ecb3abafdbc13bdd74d18d938576fbe57d93dfe73b01d42cfc"
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