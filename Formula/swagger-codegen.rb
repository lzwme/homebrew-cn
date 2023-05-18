class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://ghproxy.com/https://github.com/swagger-api/swagger-codegen/archive/v3.0.43.tar.gz"
  sha256 "b8f1431b0b97b8b1ca18c236dc584f14e9a85350c2a4e9715d626630fe6e0bdc"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c21a088ce0fbcabdb50d7310d03d2bc4d04b2ed1ccf0c8a0854949b691f02206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5f2da125c75e9dec32ad3e1611354a8e25b8d8500ac25ce5a780954fa23182f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b181422ad3a959661025c99a793561ca07b6a5cf49ab6466c03843a59241bd12"
    sha256 cellar: :any_skip_relocation, ventura:        "5c7ab5ebadc5e152a6098cd8f6e789d43da441b69f59235c5d2f66f3c3233eec"
    sha256 cellar: :any_skip_relocation, monterey:       "70e349660d9e9a9674c20cfcbf1078efbcc8f4e0fc886f441ea1956a279583dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0969711ef981eee38bbd6ae92a1af2a883dda1aa130a73690b4fcd80f87a8ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4a570fa073af3a9a1ccc829d606e2a6f867e03e8202518b3e6fca3aeb37a5b7"
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