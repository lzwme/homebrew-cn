class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https:pulsar.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=pulsarpulsar-4.0.1apache-pulsar-4.0.1-src.tar.gz"
  mirror "https:archive.apache.orgdistpulsarpulsar-4.0.1apache-pulsar-4.0.1-src.tar.gz"
  sha256 "176d92916b5488638003dd671345ba8698f7b1c12b878cb1b4ce0f83e48876a9"
  license "Apache-2.0"
  head "https:github.comapachepulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9189701c8f2a3a598630ea646a20ea82366faf821e7eee8b324c491011382153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fad02999ad77048322efc067e679775062f18552ef06e95cb32000cd83b81ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0305759a3d87db50cc145af4db6a6cbe843b8a2b49125e7c57f911e08c9d5de"
    sha256 cellar: :any_skip_relocation, sonoma:        "942ab1cdde82561b0ab19a2e16f8ae743d4f68d1a719f65c9a491a905670a94c"
    sha256 cellar: :any_skip_relocation, ventura:       "13e4c27f76db1fabfcbcba5a28c554e6510b84a8ac705f2c1e4a208d9e7ef4b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ebaf13a0ab5730f9e35eda3d84a394dd4e842f6b336f4478c396ab0d667d189"
  end

  depends_on "maven" => :build
  depends_on "protoc-gen-grpc-java" => :build
  depends_on "openjdk@21"

  def install
    # Avoid using pre-built `protoc-gen-grpc-java`
    grpc_java_files = ["pulsar-clientpom.xml", "pulsar-functionsprotopom.xml"]
    plugin_artifact = "io.grpc:protoc-gen-grpc-java:${protoc-gen-grpc-java.version}:exe:${os.detected.classifier}"
    inreplace grpc_java_files, %r{<pluginArtifact>#{Regexp.escape(plugin_artifact)}\s*<pluginArtifact>}, ""

    java_home_env = Language::Java.java_home_env("21")
    with_env(TMPDIR: buildpath, **java_home_env) do
      system "mvn", "clean", "package", "-DskipTests", "-Pcore-modules"
    end

    tarball = if build.head?
      Dir["distributionservertargetapache-pulsar-*-bin.tar.gz"].first
    else
      "distributionservertargetapache-pulsar-#{version}-bin.tar.gz"
    end

    libexec.mkpath
    system "tar", "--extract", "--file", tarball, "--directory", libexec, "--strip-components=1"
    pkgshare.install libexec"examples"
    (etc"pulsar").install_symlink libexec"conf"

    rm libexec.glob("bin*.cmd")
    libexec.glob("bin*") do |path|
      next if !path.file? || path.fnmatch?("*common.sh")

      (binpath.basename).write_env_script path, java_home_env
    end
  end

  def post_install
    (var"logpulsar").mkpath
  end

  service do
    run [opt_bin"pulsar", "standalone"]
    log_path var"logpulsaroutput.log"
    error_log_path var"logpulsarerror.log"
  end

  test do
    ENV["PULSAR_GC_LOG"] = "-Xlog:gc*:#{testpath}pulsar_gc_%p.log:time,uptime:filecount=10,filesize=20M"
    ENV["PULSAR_LOG_DIR"] = testpath
    ENV["PULSAR_STANDALONE_USE_ZOOKEEPER"] = "1"

    spawn bin"pulsar", "standalone", "--zookeeper-dir", "#{testpath}zk", "--bookkeeper-dir", "#{testpath}bk"
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("#{bin}pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end