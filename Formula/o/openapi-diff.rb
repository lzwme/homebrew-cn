class OpenapiDiff < Formula
  desc "Utility for comparing two OpenAPI specifications"
  homepage "https:github.comOpenAPIToolsopenapi-diff"
  url "https:github.comOpenAPIToolsopenapi-diffarchiverefstags2.0.1.tar.gz"
  sha256 "920e9e9fc126b78aed6900cac18533a6f08348e26aab8e1fd67a9409703548ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1451c9c5af1a9be6e803e1eadcd7ac808a3ce3eb9fd0ae3229c8ed39af0b795"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    system "mvn", "clean", "install", "-DskipTests"
    libexec.install "clitargetopenapi-diff-cli-#{version}-all.jar" => "openapi-diff-cli-all.jar"
    bin.write_jar_script libexec"openapi-diff-cli-all.jar", "openapi-diff"
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https:raw.githubusercontent.comTufinoasdiff8fdb99634d0f7f827810ee1ba7b23aa4ada8b124dataopenapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https:raw.githubusercontent.comTufinoasdiff8fdb99634d0f7f827810ee1ba7b23aa4ada8b124dataopenapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    output = shell_output("#{bin}openapi-diff openapi-test1.yaml openapi-test5.yaml")
    assert_includes output, "API CHANGE LOG"
    assert_includes output, "API changes broke backward compatibility"
  end
end