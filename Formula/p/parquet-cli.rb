class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https:parquet.apache.org"
  url "https:github.comapacheparquet-javaarchiverefstagsapache-parquet-1.14.1.tar.gz"
  sha256 "e187ec57c60e1057f4c91a38fd9fb10a636b56b0dac5b2d25649e85901a61434"
  license "Apache-2.0"
  revision 1
  head "https:github.comapacheparquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03f56b713e81de3fa9d7e4a3f221f0f1b750d1f11fc58d5d4598b92cef8fcbe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03f56b713e81de3fa9d7e4a3f221f0f1b750d1f11fc58d5d4598b92cef8fcbe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f56b713e81de3fa9d7e4a3f221f0f1b750d1f11fc58d5d4598b92cef8fcbe2"
    sha256 cellar: :any_skip_relocation, sonoma:         "03f56b713e81de3fa9d7e4a3f221f0f1b750d1f11fc58d5d4598b92cef8fcbe2"
    sha256 cellar: :any_skip_relocation, ventura:        "03f56b713e81de3fa9d7e4a3f221f0f1b750d1f11fc58d5d4598b92cef8fcbe2"
    sha256 cellar: :any_skip_relocation, monterey:       "03f56b713e81de3fa9d7e4a3f221f0f1b750d1f11fc58d5d4598b92cef8fcbe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f326610a01ab876bd7c14384ea07d3765ac83f77dcd034f76640ec3277ba11c"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    cd "parquet-cli" do
      system "mvn", "clean", "package", "-DskipTests=true"
      system "mvn", "dependency:copy-dependencies"
      libexec.install "targetparquet-cli-#{version}.jar"
      libexec.install Dir["targetdependency*"]
      (bin"parquet").write <<~EOS
        #!binsh
        set -e
        exec "#{Formula["openjdk"].opt_bin}java" -cp "#{libexec}*" org.apache.parquet.cli.Main "$@"
      EOS
    end

    (pkgshare"test").install "parquet-avrosrctestavrostringBehavior.avsc"
    (pkgshare"test").install "parquet-avrosrctestresourcesstrings-2.parquet"
  end

  test do
    output = shell_output("#{bin}parquet schema #{pkgshare}teststringBehavior.avsc")
    assert_match <<~EOS, output
      {
        "type" : "record",
        "name" : "StringBehaviorTest",
        "namespace" : "org.apache.parquet.avro",
        "fields" : [ {
          "name" : "default_class",
          "type" : "string"
        }, {
    EOS

    output = shell_output("#{bin}parquet schema #{pkgshare}teststrings-2.parquet")
    assert_match <<~EOS, output
      {
        "type" : "record",
        "name" : "mystring",
        "fields" : [ {
          "name" : "text",
          "type" : "string"
        } ]
      }
    EOS
  end
end