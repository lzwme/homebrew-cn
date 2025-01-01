class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.2.tgz"
  sha256 "f3561b77912bb7ed438b999874b6818e1305c8f8ff4881c40a7b0b6bebca07f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1564e98f7173d901bc04dc29eba29ecef101594781856d0aa897f9eec69bf6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab703d4b0be56848daf1721536473d48b48db7c5a46b0b12716fea64ff6409d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23f228014ffac4e4ac367f2f1985b8bcaa85bdac0812ad16cb16b23b30afa429"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7da17b4a11dc670873bf20f69c5f1ef231c81d842ff1372a986bbb01c764ca8"
    sha256 cellar: :any_skip_relocation, ventura:       "4a0b7d5abf710c5666debab8582ab2cf0db813c7721203fd536bd701431eb827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd8e84dd490c4855682ee16119b9af71632f580bdaf28bbd7df75171b65eb11"
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