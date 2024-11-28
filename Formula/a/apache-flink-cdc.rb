class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https:nightlies.apache.orgflinkflink-cdc-docs-stable"
  url "https:www.apache.orgdynmirrorsmirrors.cgi?action=download&filename=flinkflink-cdc-3.2.1flink-cdc-3.2.1-bin.tar.gz"
  mirror "https:archive.apache.orgdistflinkflink-cdc-3.2.1flink-cdc-3.2.1-bin.tar.gz"
  sha256 "4e011bfc199d8a39c907eb4ce62a1bd9818a80b5d7044253565ddd5db71ad24b"
  license "Apache-2.0"
  head "https:github.comapacheflink-cdc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6116bd41efd4a1104463f34261e854a6d0799e25159611ee2482d1d7aabb94f"
  end

  depends_on "apache-flink" => :test

  resource "mysql-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-mysql3.2.1flink-cdc-pipeline-connector-mysql-3.2.1.jar"
    sha256 "b40bbc5360be6c913746580489ce93c60ee3a1595097b59b1cf22ee90a8fb346"
  end
  resource "paimon-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-paimon3.2.1flink-cdc-pipeline-connector-paimon-3.2.1.jar"
    sha256 "cff1cf99f6caf1cd0977150030b30af1cdc867596cba00803cc2c0ca7bad0f36"
  end
  resource "kafka-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-kafka3.2.1flink-cdc-pipeline-connector-kafka-3.2.1.jar"
    sha256 "deab1af95a88b796b8a1df5dc636a2707884459a24d08ce08318cba56cc8c23d"
  end
  resource "doris-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-doris3.2.1flink-cdc-pipeline-connector-doris-3.2.1.jar"
    sha256 "1fe3d5ef1854e9038e258a9f2ed88fd41831cf0030efd54d73aad49e9eb69295"
  end
  resource "starrocks-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-starrocks3.2.1flink-cdc-pipeline-connector-starrocks-3.2.1.jar"
    sha256 "d78b7799893fe7351223b343838af52f17c26f978bebdab5b16545305d44fa1d"
  end
  resource "values-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-values3.2.1flink-cdc-pipeline-connector-values-3.2.1.jar"
    sha256 "e4f04e7e1084775f5d85eb0789fbe4b40d9d6a9b97ec735b403f3a8282f28207"
  end

  def install
    # Install launch script
    mv "binflink-cdc.sh", "binflink-cdc"
    libexec.install "bin"
    bin.write_exec_script libexec"binflink-cdc"
    inreplace libexec"binflink-cdc" do |s|
      # Specify FLINK_CDC_HOME explicitly
      s.sub! "FLINK_CDC_HOME=\"$SCRIPT_DIR\"..", "FLINK_CDC_HOME=\"#{libexec}\""
    end

    # Install connector libraries
    libexec.install "lib"
    resources.each { |connector| (libexec"lib").install connector }

    # Store configs in etc, outside of keg
    pkgetc.install Dir["conf*"]
    libexec.install_symlink pkgetc => "conf"
  end

  def post_install
    (var"logapache-flink-cdc").mkpath
    libexec.install_symlink var"logapache-flink-cdc" => "log"
  end

  test do
    (testpath"test-pipeline.yaml").write <<~YAML
      source:
        name: Dummy data source
        type: values

      sink:
        name: Dummy data sink
        type: values

      pipeline:
        name: Dummy pipeline job
        parallelism: 1
    YAML
    (testpath"log").mkpath
    ENV["FLINK_LOG_DIR"] = testpath"log"
    flink_home = Formula["apache-flink"].libexec
    system flink_home"binstart-cluster.sh"
    output = shell_output "#{bin}flink-cdc --flink-home #{flink_home} #{testpath}test-pipeline.yaml"
    assert_match "Pipeline has been submitted to cluster.", output
    system flink_home"binstop-cluster.sh"
  end
end