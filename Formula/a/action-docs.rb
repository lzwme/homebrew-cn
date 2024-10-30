class ActionDocs < Formula
  desc "Generate docs for GitHub actions"
  homepage "https:github.comnpalmaction-docs"
  url "https:registry.npmjs.orgaction-docs-action-docs-2.5.0.tgz"
  sha256 "109170e521e4096b571932a6c0af640db48d1d82c3023488c70f0c909787792e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "abd1926961e5319b5400d918b66417b6e187855983f47f2182d2de1fe7d699af"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    test_file = testpath"action.yml"
    test_file.write <<~YAML
      ---
      name: "Example name"
      description: "Example action description"
      author: "Example action author"
      inputs:
        example:
          description: "Example input description"
          required: false
      runs:
        using: "composite"
        steps:
          - id: random-number-generator
            run: echo "random-id=$(echo $RANDOM)" >> $GITHUB_OUTPUT
            shell: bash
    YAML

    output = shell_output("#{bin}action-docs --source #{test_file}")
    assert_match "Example input description", output

    assert_match version.to_s, shell_output("#{bin}action-docs --version")
  end
end