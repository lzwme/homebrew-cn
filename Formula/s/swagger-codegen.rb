class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.52.tar.gz"
  sha256 "3d405a92d3d155edbbf7e06208a66538e44e58cfefb7f02cc251fda4caf76746"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d638190fc11dca768d812fb60cf37489b70bf33031247493190847fcf84a3655"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aad1fbcd24907398743e2e213054bb64f3a3a3e204a9917bbedc5d0fbb294ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad1fbcd24907398743e2e213054bb64f3a3a3e204a9917bbedc5d0fbb294ff4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e245ee69ca71bf3f99c580c4e45a045d9d8adcfd8d994477439f889a58418a6"
    sha256 cellar: :any_skip_relocation, ventura:        "fe1022c04f420f7ad105663b8443827acb50d780f88668750b5805cf40c5c204"
    sha256 cellar: :any_skip_relocation, monterey:       "d0ff649045e352ef0bc6485515e88797eb6922a7e7ef0053ff92f1d0733affab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13d9f4de8a5d140245f29901f3394dcb5d418a447ba861a610ef8361c5903722"
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
    system "#{bin}swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath"index.html"), "<h1>Simple API<h1>"
  end
end