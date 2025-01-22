class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https:nightlies.apache.orgflinkflink-cdc-docs-stable"
  url "https:www.apache.orgdynmirrorsmirrors.cgi?action=download&filename=flinkflink-cdc-3.3.0flink-cdc-3.3.0-bin.tar.gz"
  mirror "https:archive.apache.orgdistflinkflink-cdc-3.3.0flink-cdc-3.3.0-bin.tar.gz"
  sha256 "efb6a5e36bcb85550c367cb39104ee7fcbacfd8124190a2fc3e547ca19446719"
  license "Apache-2.0"
  head "https:github.comapacheflink-cdc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68208a88aaed1d60d35718e6c47548d1f4939b4a18ea008d857b76c931de0745"
  end

  depends_on "apache-flink" => :test

  resource "mysql-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-mysql3.3.0flink-cdc-pipeline-connector-mysql-3.3.0.jar"
    sha256 "6e1af3675279e11c3e0240ca0475910c13bf75ecfd1ab23c0077a5fabc65c44a"
  end
  resource "paimon-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-paimon3.3.0flink-cdc-pipeline-connector-paimon-3.3.0.jar"
    sha256 "aff379b173bbde7383ef703211f63cf4e0e1eaac8bba7af1757ccf60fc2b2126"
  end
  resource "kafka-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-kafka3.3.0flink-cdc-pipeline-connector-kafka-3.3.0.jar"
    sha256 "988af808ba3c2b1bc2ac7c4e79388615ecd2d0614b5ccba48362b526ae1b98e9"
  end
  resource "doris-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-doris3.3.0flink-cdc-pipeline-connector-doris-3.3.0.jar"
    sha256 "112981b8bb216fa08928c12abc0a7ce3d2772f22c06d417e2426884e4f880304"
  end
  resource "starrocks-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-starrocks3.3.0flink-cdc-pipeline-connector-starrocks-3.3.0.jar"
    sha256 "3bf443e4f339dc1532a2fb3870d014be4f40fb82ac58edbb09dde284a64886c0"
  end
  resource "values-connector" do
    url "https:search.maven.orgremotecontent?filepath=orgapacheflinkflink-cdc-pipeline-connector-values3.3.0flink-cdc-pipeline-connector-values-3.3.0.jar"
    sha256 "0854e61ba6016df5c13ae99fe78aabc278a5bbf4bcb3c029402a6bf7de96a93b"
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