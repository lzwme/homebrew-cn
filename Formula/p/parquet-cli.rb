class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https:parquet.apache.org"
  url "https:github.comapacheparquet-mr.git",
      tag:      "apache-parquet-1.14.1",
      revision: "97ede968377400d1d79e3196636ba3de392196ba"
  license "Apache-2.0"
  head "https:github.comapacheparquet-mr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6e33538fcca9b9bd16232ce073ee5626302003c7a8786a293ab76987d22308b3"
  end

  depends_on "maven" => :build

  # parquet-cli has problems running on Linux, for more information:
  # https:github.comHomebrewhomebrew-corepull94318#issuecomment-1049229342
  depends_on :macos

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
  end
end