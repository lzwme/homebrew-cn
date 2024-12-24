class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.0.tgz"
  sha256 "1074418de87b93aea3f63f42f95823a30b01787e87a4de104f62f58237afb7d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85bf7b86ff7d08c0a5f111dd2c87d071f2a2275f4e1be6da90501e7f0eebe82e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "325dbf5f0e1d39924baed4fa4749daa1fe4790129c1963845c109fb633a2ed4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e7464d9ef949c4ef0764373fed9f3b2df925d7c6ca36ad4bc3127720d8da4b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c234354e74060f4b105a034515758c97b554e535ee80f344744c0e736a6b281"
    sha256 cellar: :any_skip_relocation, ventura:       "f3d5f1c9f785067a5e98b2f92bc7ef33b2a24d770ad49298a5a2fc3c22d8d0a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26d031a160d61923969b56ad3fbeadb1e594a9189bdcf1280c6f0ca7e3ba0834"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end