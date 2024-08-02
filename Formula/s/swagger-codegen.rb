class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.60.tar.gz"
  sha256 "c39e15d06b4d85f68dc93b93aef325e747d310673cb9197a9c9ecc557e899deb"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7e9c612c2d0d60719764553bd0c4fcb002f02e3f9b48b90b715f1b424567299"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d3ae6c279b87174e38578a1410b0f247d19be82afddf690995fce886cad7a84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a07552e25c0acf71cc6ad811c7a0167af714a517a2ff4b554f2d1c77979b1b8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "715155847aaba4f82178eb0fec1b1b84d6d53d27e7400ff18ce20f3b5ebef215"
    sha256 cellar: :any_skip_relocation, ventura:        "85c1a30d7ee0c295b6ba9ac57abf243e5c7de7003ac5c217516a46450fbab26a"
    sha256 cellar: :any_skip_relocation, monterey:       "7626461dbc900dde9131b990c1575e90c5866f55d8d54d09b261b6c0ea161de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae7f4b0b6f7efc216dba58d4e3d27813bce4b9a182ec051bfb3bc162ac40632"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modulesswagger-codegen-clitargetswagger-codegen-cli.jar"
    bin.write_jar_script libexec"swagger-codegen-cli.jar", "swagger-codegen", java_version: "11"
  end

  test do
    (testpath"minimal.yaml").write <<~EOS
      ---
      openapi: 3.0.0
      info:
        version: 0.0.0
        title: Simple API
      paths:
        :
          get:
            responses:
              200:
                description: OK
    EOS
    system bin"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath"index.html"), "<h1>Simple API<h1>"
  end
end