class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https:parquet.apache.org"
  url "https:github.comapacheparquet-javaarchiverefstagsapache-parquet-1.14.4.tar.gz"
  sha256 "ee8a78ff21a9db834d50f844e41a6adc1f4ebdb66e3895d28ef0e41b2da8139b"
  license "Apache-2.0"
  head "https:github.comapacheparquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7541194dc0aa7f1a94698d2eae02143352148162ee70514e9a3bc6e83693c081"
  end

  depends_on "maven" => :build
  # Try switching back to `openjdk` when the issue below is resolved and
  # Hadoop dependency is updated to include the fixworkaround.
  # https:issues.apache.orgjirabrowseHADOOP-19212
  depends_on "openjdk@21"

  def install
    cd "parquet-cli" do
      system "mvn", "clean", "package", "-DskipTests=true"
      system "mvn", "dependency:copy-dependencies"
      libexec.install "targetparquet-cli-#{version}.jar"
      libexec.install Dir["targetdependency*"]
      (bin"parquet").write <<~EOS
        #!binsh
        set -e
        exec "#{Formula["openjdk@21"].opt_bin}java" -cp "#{libexec}*" org.apache.parquet.cli.Main "$@"
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