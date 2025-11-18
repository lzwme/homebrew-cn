class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.1.2/apache-pulsar-4.1.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.1.2/apache-pulsar-4.1.2-src.tar.gz"
  sha256 "2b12b98ca35761ad471c3bafdc6647aeff0ad4b128f9d05595483db3dc08798e"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac67ad06e5913ad1f5a23ac4209a9735058713cf12a5d1098806c87004c25a6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c4a4e4e0ee4eb74d5ca8b5f5d3b487daac341778e551d858f9add5f5e74401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bd254965c5242de2884edb918d5b34dd6edb012a82e352d3271e485d53f4ca1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fb788d0fc206a81777846a7013ebaa504c7904227db11ad1c011baea2cd0c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb68940c4e38ca5ff6be4bc6f8cbd246690522d4bc9ebdfb3f86c082f252804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e2c84310f137d2bea6bd239d930c5e72f0dbdc3c2308eceeaabe20143a0c29e"
  end

  depends_on "maven" => :build
  depends_on "protoc-gen-grpc-java" => :build
  depends_on "openjdk@21"

  def install
    # Pin gRPC Java version to that of protoc-gen-grpc-java
    inreplace "pom.xml",
              %r{<grpc.version>\d+(?:\.\d+)+</grpc.version>},
              "<grpc.version>#{Formula["protoc-gen-grpc-java"].version}</grpc.version>"

    # Avoid using pre-built `protoc-gen-grpc-java`
    grpc_java_files = ["pulsar-client/pom.xml", "pulsar-functions/proto/pom.xml"]
    plugin_artifact = "io.grpc:protoc-gen-grpc-java:${protoc-gen-grpc-java.version}:exe:${os.detected.classifier}"
    inreplace grpc_java_files, %r{<pluginArtifact>#{Regexp.escape(plugin_artifact)}\s*</pluginArtifact>}, ""

    java_home_env = Language::Java.java_home_env("21")
    with_env(TMPDIR: buildpath, **java_home_env) do
      system "mvn", "clean", "package", "-DskipTests", "-Pcore-modules"
    end

    tarball = if build.head?
      Dir["distribution/server/target/apache-pulsar-*-bin.tar.gz"].first
    else
      "distribution/server/target/apache-pulsar-#{version}-bin.tar.gz"
    end

    libexec.mkpath
    system "tar", "--extract", "--file", tarball, "--directory", libexec, "--strip-components=1"
    pkgshare.install libexec/"examples"
    (etc/"pulsar").install_symlink libexec/"conf"

    rm libexec.glob("bin/*.cmd")
    libexec.glob("bin/*") do |path|
      next if !path.file? || path.fnmatch?("*common.sh")

      (bin/path.basename).write_env_script path, java_home_env
    end
  end

  def post_install
    (var/"log/pulsar").mkpath
  end

  service do
    run [opt_bin/"pulsar", "standalone"]
    log_path var/"log/pulsar/output.log"
    error_log_path var/"log/pulsar/error.log"
  end

  test do
    ENV["PULSAR_GC_LOG"] = "-Xlog:gc*:#{testpath}/pulsar_gc_%p.log:time,uptime:filecount=10,filesize=20M"
    ENV["PULSAR_LOG_DIR"] = testpath
    ENV["PULSAR_STANDALONE_USE_ZOOKEEPER"] = "1"

    spawn bin/"pulsar", "standalone", "--zookeeper-dir", "#{testpath}/zk", "--bookkeeper-dir", "#{testpath}/bk"
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("#{bin}/pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}/pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end