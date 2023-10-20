class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://ghproxy.com/https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.48.tar.gz"
  sha256 "7a42729709136a5a134ae6f45bfc90911069e0248548829b69a836eb93a8a13b"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48dee7b120c42fe0fb6c0ff392bb870ce9870563b4a5a0a064deddf1a596bbba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4c8dee620e7590bce8dbbc5955ecd424fc29a12d6e93cf0fc932ac49b702d82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b19567b58374cf4fca7b6609aba499f76b483a480e3747f3b2bc2041240c3c81"
    sha256 cellar: :any_skip_relocation, sonoma:         "8691cffd2c48c69115d386f621f77a16ee750c3eeb5e5e2fc27567e9a93d85c2"
    sha256 cellar: :any_skip_relocation, ventura:        "76cc9bf71404d178c20ab761a54d675e4451b16d12f6e451f0cb4c936e6d3bfd"
    sha256 cellar: :any_skip_relocation, monterey:       "cf6cb6a89d3fcc988ff282fe1e64550627d4ccd85fe8a870d79652b8ce4b85f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7500faa68f44e27584bb433c66448ea4d516b71a61a4eb7e2dd949c11eb8040"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "11"
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
      ---
      openapi: 3.0.0
      info:
        version: 0.0.0
        title: Simple API
      paths:
        /:
          get:
            responses:
              200:
                description: OK
    EOS
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end