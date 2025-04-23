class Kafka < Formula
  desc "Open-source distributed event streaming platform"
  homepage "https:kafka.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=kafka4.0.0kafka_2.13-4.0.0.tgz"
  mirror "https:archive.apache.orgdistkafka4.0.0kafka_2.13-4.0.0.tgz"
  sha256 "7b852e938bc09de10cd96eca3755258c7d25fb89dbdd76305717607e1835e2aa"
  license "Apache-2.0"

  livecheck do
    url "https:kafka.apache.orgdownloads"
    regex(href=.*?kafka[._-]v?\d+(?:\.\d+)+-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73ba51ee035a8ffecc3b205a8272ac62c0529a4e52f48f114ad3e8404405b288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ba51ee035a8ffecc3b205a8272ac62c0529a4e52f48f114ad3e8404405b288"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73ba51ee035a8ffecc3b205a8272ac62c0529a4e52f48f114ad3e8404405b288"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a40fd21ee87eb2d0bf44f106f3a7d599ebc3a47e64892151b49f76f00897fb0"
    sha256 cellar: :any_skip_relocation, ventura:       "0a40fd21ee87eb2d0bf44f106f3a7d599ebc3a47e64892151b49f76f00897fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73ba51ee035a8ffecc3b205a8272ac62c0529a4e52f48f114ad3e8404405b288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73ba51ee035a8ffecc3b205a8272ac62c0529a4e52f48f114ad3e8404405b288"
  end

  depends_on "openjdk"

  def install
    data = var"lib"

    inreplace "configserver.properties",
      "log.dirs=tmpkraft-combined-logs", "log.dirs=#{data}kraft-combined-logs"
    inreplace "configcontroller.properties",
      "log.dirs=tmpkraft-controller-logs", "log.dirs=#{data}kraft-controller-logs"
    inreplace "configconnect-standalone.properties",
      "filename=tmpconnect.offsets", "filename=#{data}connect.offsets"
    inreplace "configbroker.properties",
      "log.dirs=tmpkraft-broker-logs", "log.dirs=#{data}kraft-broker-logs"

    # remove Windows scripts
    rm_r("binwindows")

    libexec.install "libs"

    prefix.install "bin"
    bin.env_script_all_files(libexec"bin", Language::Java.overridable_java_home_env)
    Dir["#{bin}*.sh"].each { |f| mv f, f.to_s.gsub(.sh$, "") }

    mv "config", "kafka"
    etc.install "kafka"
    libexec.install_symlink etc"kafka" => "config"
  end

  def post_install
    # create directory for kafka stdout+stderr output logs when run by launchd
    (var"logkafka").mkpath

    generate_log_dir(etc"kafkaserver.properties") unless (var"libkraft-combined-logsmeta.properties").exist?
  end

  def generate_log_dir(path)
    uuid = Utils.safe_popen_read(bin"kafka-storage", "random-uuid").strip
    system bin"kafka-storage", "format", "--standalone",
           "-t", uuid, "-c", path
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
    cp "#{etc}kafkaserver.properties", testpath"kafka"

    kafka_port = free_port
    controller_port = free_port
    inreplace "#{testpath}kafkaserver.properties" do |s|
      s.gsub! "#{var}lib", testpath
      s.gsub! "controller.quorum.bootstrap.servers=localhost:9093",
              "controller.quorum.bootstrap.servers=localhost:#{controller_port}"
      s.gsub! "listeners=PLAINTEXT::9092,CONTROLLER::9093",
              "listeners=PLAINTEXT::#{kafka_port},CONTROLLER::#{controller_port}"
      s.gsub! "advertised.listeners=PLAINTEXT:localhost:9092,CONTROLLER:localhost:9093",
              "advertised.listeners=PLAINTEXT:localhost:#{kafka_port},CONTROLLER:localhost:#{controller_port}"
    end

    generate_log_dir(testpath"kafkaserver.properties")

    begin
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
      system bin"kafka-server-stop"
      sleep 10
    end

    assert_match(test message, File.read("#{testpath}kafkademo.out"))
  end
end