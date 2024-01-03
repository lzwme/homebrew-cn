class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.51.tar.gz"
  sha256 "6c41229d8a864dc71f4941670ecf26e95c7f8fb5dc2f9d03a29ff3a1ae10852a"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e7f69138527c704315f168b43c10bd13c711792ac7c8e4fde9258becd31028c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1480328ca2e4ea41b6806fa77aa3b6da6f89255c95f1080350f65facbdcfcdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5bbc040a81a82bd41de0ce07750d879d3b1ebad3f59fbbd5bde59a9d10ec622"
    sha256 cellar: :any_skip_relocation, sonoma:         "98fe0663c052234271445bbc1378b0fa55fe7a0320390a4d69f11ce54472804c"
    sha256 cellar: :any_skip_relocation, ventura:        "5714c7855cd44e1da82752446dff3b9230970a45238c76fb710f31b67b7d9aba"
    sha256 cellar: :any_skip_relocation, monterey:       "fd7893b712f7fd62445efd56549d3061fd227a5d5265c565e0632a18ef859e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae758dda9d6f6eb0e21a87260a642a9151804926a8a3b0dd43fa39311997a70"
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