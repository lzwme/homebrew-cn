class Kafka < Formula
  desc "Open-source distributed event streaming platform"
  homepage "https:kafka.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=kafka3.7.1kafka_2.13-3.7.1.tgz"
  mirror "https:archive.apache.orgdistkafka3.7.1kafka_2.13-3.7.1.tgz"
  sha256 "62acae4a143dd983dc7eb4804d5744ba0c50b199b508f599ef001020e2558fc9"
  license "Apache-2.0"

  livecheck do
    url "https:kafka.apache.orgdownloads"
    regex(href=.*?kafka[._-]v?\d+(?:\.\d+)+-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "713470e63a1e0228f6bc4725c69f0b471308963362b9f37e97893fbf539a503e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "713470e63a1e0228f6bc4725c69f0b471308963362b9f37e97893fbf539a503e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "713470e63a1e0228f6bc4725c69f0b471308963362b9f37e97893fbf539a503e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a013fc62f61bc92944d3b93d97f0d3472046f71594b9b3f5dee93ebe1571995"
    sha256 cellar: :any_skip_relocation, ventura:        "2a013fc62f61bc92944d3b93d97f0d3472046f71594b9b3f5dee93ebe1571995"
    sha256 cellar: :any_skip_relocation, monterey:       "2a013fc62f61bc92944d3b93d97f0d3472046f71594b9b3f5dee93ebe1571995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d979b68d9cf2fe3f8b661775720bd9b9be45da831d9a9b07bad0a5d73e9d623a"
  end

  depends_on "openjdk"
  depends_on "zookeeper"

  def install
    data = var"lib"
    inreplace "configserver.properties",
      "log.dirs=tmpkafka-logs", "log.dirs=#{data}kafka-logs"

    inreplace "configkraftserver.properties",
      "log.dirs=tmpkraft-combined-logs", "log.dirs=#{data}kraft-combined-logs"

    inreplace "configkraftcontroller.properties",
      "log.dirs=tmpkraft-controller-logs", "log.dirs=#{data}kraft-controller-logs"

    inreplace "configkraftbroker.properties",
      "log.dirs=tmpkraft-broker-logs", "log.dirs=#{data}kraft-broker-logs"

    inreplace "configzookeeper.properties",
      "dataDir=tmpzookeeper", "dataDir=#{data}zookeeper"

    # remove Windows scripts
    rm_r("binwindows")

    libexec.install "libs"

    prefix.install "bin"
    bin.env_script_all_files(libexec"bin", Language::Java.overridable_java_home_env)
    Dir["#{bin}*.sh"].each { |f| mv f, f.to_s.gsub(.sh$, "") }

    mv "config", "kafka"
    etc.install "kafka"
    libexec.install_symlink etc"kafka" => "config"

    # create directory for kafka stdout+stderr output logs when run by launchd
    (var+"logkafka").mkpath
  end

  service do
    run [opt_bin"kafka-server-start", etc"kafkaserver.properties"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logkafkakafka_output.log"
    error_log_path var"logkafkakafka_output.log"
  end

  test do
    ENV["LOG_DIR"] = "#{testpath}kafkalog"

    # Workaround for https:issues.apache.orgjirabrowseKAFKA-15413
    # See https:github.comHomebrewhomebrew-corepull133887#issuecomment-1679907729
    ENV.delete "COLUMNS"

    (testpath"kafka").mkpath
    cp "#{etc}kafkazookeeper.properties", testpath"kafka"
    cp "#{etc}kafkaserver.properties", testpath"kafka"
    inreplace "#{testpath}kafkazookeeper.properties", "#{var}lib", testpath
    inreplace "#{testpath}kafkaserver.properties", "#{var}lib", testpath

    zk_port = free_port
    kafka_port = free_port
    inreplace "#{testpath}kafkazookeeper.properties", "clientPort=2181", "clientPort=#{zk_port}"
    inreplace "#{testpath}kafkaserver.properties" do |s|
      s.gsub! "zookeeper.connect=localhost:2181", "zookeeper.connect=localhost:#{zk_port}"
      s.gsub! "#listeners=PLAINTEXT::9092", "listeners=PLAINTEXT::#{kafka_port}"
    end

    begin
      fork do
        exec "#{bin}zookeeper-server-start #{testpath}kafkazookeeper.properties " \
             "> #{testpath}test.zookeeper-server-start.log 2>&1"
      end

      sleep 15

      fork do
        exec "#{bin}kafka-server-start #{testpath}kafkaserver.properties " \
             "> #{testpath}test.kafka-server-start.log 2>&1"
      end

      sleep 30

      system "#{bin}kafka-topics --bootstrap-server localhost:#{kafka_port} --create --if-not-exists " \
             "--replication-factor 1 --partitions 1 --topic test > #{testpath}kafkademo.out " \
             "2>devnull"
      pipe_output "#{bin}kafka-console-producer --bootstrap-server localhost:#{kafka_port} --topic test 2>devnull",
                  "test message"
      system "#{bin}kafka-console-consumer --bootstrap-server localhost:#{kafka_port} --topic test " \
             "--from-beginning --max-messages 1 >> #{testpath}kafkademo.out 2>devnull"
      system "#{bin}kafka-topics --bootstrap-server localhost:#{kafka_port} --delete --topic test " \
             ">> #{testpath}kafkademo.out 2>devnull"
    ensure
      system "#{bin}kafka-server-stop"
      system "#{bin}zookeeper-server-stop"
      sleep 10
    end

    assert_match(test message, File.read("#{testpath}kafkademo.out"))
  end
end