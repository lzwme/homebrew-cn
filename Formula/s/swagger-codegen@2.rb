class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv2.4.45.tar.gz"
  sha256 "fbad0e8c547ccfe2389ab880cd8f698af2d69f4fed2dee9bca6e802aca579c09"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(2(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9194bd4596240c5995137885ba10d9dbe8ae0f877a9fd0faed456eba3ce7b4fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72c914929b6bdcaa1287fe5bf2bcbabdad0742a9635a66136984773447eedfc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfdb01219415b545225b331b05ec3318719edc27879cc51335b9655951a1b0e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfc5afbaabeb86f4c1500f8fc6905ae132ab485f11aa5b72d946a51b96432d2c"
    sha256 cellar: :any_skip_relocation, ventura:       "b9d435a397fb3935c32ad5f7a9fa41446fa2caf13b852c259098d73d47515782"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da4e1fc325f81e3a045a6f24942824f1bc546bc276368bd32393005d839cee0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e06d360af67bb9f61b3706c92630ca4b0f05f9a2acdc413f7fd8061db5becfc"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    java_version = "21"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    system "mvn", "clean", "package"
    libexec.install "modulesswagger-codegen-clitargetswagger-codegen-cli.jar"
    bin.write_jar_script(libexec"swagger-codegen-cli.jar", "swagger-codegen", java_version:)
  end

  test do
    (testpath"minimal.yaml").write <<~YAML
      ---
      swagger: '2.0'
      info:
        version: 0.0.0
        title: Simple API
      paths:
        :
          get:
            responses:
              200:
                description: OK
    YAML

    system bin"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes (testpath"index.html").read, "<h1>Simple API<h1>"
  end
end