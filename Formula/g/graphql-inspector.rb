class GraphqlInspector < Formula
  desc "Validate schema, get schema change notifications, validate operations, and more"
  homepage "https://the-guild.dev/graphql/inspector"
  url "https://registry.npmjs.org/@graphql-inspector/cli/-/cli-6.0.6.tgz"
  sha256 "078f8d5437b54448c8955792fd04a425ef8a5c123fb4495bc31f89446f940f92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e7bd651ec44b4a6fa2a7edd6d24b4eb17d91116f68d7198a1e0d38faf2c3a128"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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