class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://dlcdn.apache.org/druid/31.0.0/apache-druid-31.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/31.0.0/apache-druid-31.0.0-bin.tar.gz"
  sha256 "c69a40a0a352fea07c59533004fc711db3b2e6e0c6977231ac2595d53f984241"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads/"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ce14d3d0a0d03398dcc0c730019871ce33b746a3ef21bbd9f68d844da3701a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce14d3d0a0d03398dcc0c730019871ce33b746a3ef21bbd9f68d844da3701a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ce14d3d0a0d03398dcc0c730019871ce33b746a3ef21bbd9f68d844da3701a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee7305ebe8bdc866e13aff7a471e02d58306e74b40d2683a94c3e8ea96bcacda"
    sha256 cellar: :any_skip_relocation, ventura:       "ee7305ebe8bdc866e13aff7a471e02d58306e74b40d2683a94c3e8ea96bcacda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce14d3d0a0d03398dcc0c730019871ce33b746a3ef21bbd9f68d844da3701a2"
  end

  depends_on "zookeeper" => :test
  depends_on "openjdk@11"

  resource "mysql-connector-java" do
    url "https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar"
    sha256 "5bba9ff50e5e637a0996a730619dee19ccae274883a4d28c890d945252bb0e12"
  end

  def install
    libexec.install Dir["*"]

    %w[
      broker.sh
      coordinator.sh
      historical.sh
      middleManager.sh
      overlord.sh
    ].each do |sh|
      inreplace libexec/"bin/#{sh}", "./bin/node.sh", libexec/"bin/node.sh"
    end

    inreplace libexec/"bin/node.sh" do |s|
      s.gsub! "nohup \"$BIN_DIR/run-java\"",
              "nohup \"$BIN_DIR/run-java\" -Ddruid.extensions.directory=\"#{libexec}/extensions\""
      s.gsub! ":=lib", ":=#{libexec}/lib"
      s.gsub! ":=conf/druid", ":=#{libexec}/conf/druid"
      s.gsub! ":=${WHEREAMI}/log", ":=#{var}/druid/log"
      s.gsub! ":=var/druid/pids", ":=#{var}/druid/pids"
    end

    resource("mysql-connector-java").stage do
      (libexec/"extensions/mysql-metadata-storage").install Dir["*"]
    end

    bin.install Dir["#{libexec}/bin/*.sh"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("11")

    Pathname.glob("#{bin}/*.sh") do |file|
      mv file, bin/"druid-#{file.basename}"
    end
  end

  def post_install
    %w[
      druid/hadoop-tmp
      druid/indexing-logs
      druid/log
      druid/pids
      druid/segments
      druid/task
    ].each do |dir|
      (var/dir).mkpath
    end
  end

  test do
    ENV["DRUID_CONF_DIR"] = libexec/"conf/druid/single-server/nano-quickstart"
    ENV["DRUID_LOG_DIR"] = testpath
    ENV["DRUID_PID_DIR"] = testpath
    ENV["ZOO_LOG_DIR"] = testpath

    system Formula["zookeeper"].opt_bin/"zkServer", "start"
    begin
      pid = fork { exec bin/"druid-broker.sh", "start" }
      sleep 40
      output = shell_output("curl -s http://localhost:8082/status")
      assert_match "version", output
    ensure
      system bin/"druid-broker.sh", "stop"
      # force zookeeper stop since it is sometimes still alive after druid-broker.sh finishes
      system Formula["zookeeper"].opt_bin/"zkServer", "stop"
      Process.wait pid
    end
  end
end