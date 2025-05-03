class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https:parquet.apache.org"
  url "https:github.comapacheparquet-javaarchiverefstagsapache-parquet-1.15.2.tar.gz"
  sha256 "2880d7f532bd53d6780ec82e9df8f34edc9acfd95eb725747bd8205909517641"
  license "Apache-2.0"
  head "https:github.comapacheparquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "935468cd7393a349c49631272dc7d032ada87c9e2236771c46a4012cb2488c3b"
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