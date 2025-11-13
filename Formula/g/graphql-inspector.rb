class GraphqlInspector < Formula
  desc "Validate schema, get schema change notifications, validate operations, and more"
  homepage "https://the-guild.dev/graphql/inspector"
  url "https://registry.npmjs.org/@graphql-inspector/cli/-/cli-6.0.0.tgz"
  sha256 "c7d42b5bd54741e6f8e6f33fddec097e9920842149603ec2b31a0ebe66ca7e47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ad8912511bdca6ff8c18097f58efe3240762b398aba29e36b3fbfdf2942c52f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"oldSchema.graphql").write <<~GRAPHQL
      type Query {
        hello: String
      }
    GRAPHQL

    (testpath/"newSchema.graphql").write <<~GRAPHQL
      type Query {
        hello: String
        world: String
      }
    GRAPHQL

    diff_output = shell_output("#{bin}/graphql-inspector diff oldSchema.graphql newSchema.graphql")
    assert_match "Field world was added to object type Query", diff_output
    assert_match "No breaking changes detected", diff_output

    system bin/"graphql-inspector", "introspect", "oldSchema.graphql"
    assert_path_exists "graphql.schema.json"
  end
end