class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.80.0.tgz"
  sha256 "ec4fcb7173f667f3d65bfe9ca72a3d4c5cfcf89ec4b9268bbfbd84948c54a47b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f83859a8c4833983a7126a6be8d5bf2314f94fb3572fe15730e47ffbec49f2b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "536f902997bfb16a01b0c9c3ba62f097fd90d5bab41f7dba8ced42381038408e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c943ef7888e24af5cc1d3aaf396641e68c5f6894facc5a216d11536c4f8be81"
    sha256 cellar: :any_skip_relocation, sonoma:         "df84338b428dd2df61913dfc5cda809aa576748635bffcf66be2692d9253430a"
    sha256 cellar: :any_skip_relocation, ventura:        "331443ca768a9fbcdd4b8876a227468257f3a62c524b02d40b6e2f4de5480a4f"
    sha256 cellar: :any_skip_relocation, monterey:       "74c98398103acecb9a2b8dc470fc3996d8a1c38a6cda92c1b020701229c1a670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0451429b5b081b6e8d9eca64282d0a860118a5438ec53231f9ae3e499500ea88"
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