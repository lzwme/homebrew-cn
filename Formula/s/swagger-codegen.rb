class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://ghproxy.com/https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.49.tar.gz"
  sha256 "cf6c6aeba45b7095ea4ab6072810b596dc6d3540540a4c904422d37b1c1dbafd"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78b893112e80670ef7099a4763d8ecbc6874f6ba1c3739cceaa258a8f43c177b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc91fa7b9906c95551d73accf42140db60f11bbb49377198f3247b3dc8a1bbd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63e835073f5a8c501ebc18d958575dc1ad60574e258684e430b8e800da50ed4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3ca2c7191a83f280459e4d7ae4a2b81268ceec2cb2db01d178f163c276002d3"
    sha256 cellar: :any_skip_relocation, ventura:        "cf33ce16e73bd15ba3bca5fa96b2c6b85df38d1d3111b9372c31a8dd02ab74a8"
    sha256 cellar: :any_skip_relocation, monterey:       "1bcfa5513ed990e18d4b7a89d5edcaf3f8358f4e0756d995f1e4a82010fb4516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52953fc57f4cfb4619b3da407561148df11dbda6909d098fddd08fb1ffcd47c8"
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