class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https:pulsar.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=pulsarpulsar-4.0.0apache-pulsar-4.0.0-src.tar.gz"
  mirror "https:archive.apache.orgdistpulsarpulsar-4.0.0apache-pulsar-4.0.0-src.tar.gz"
  sha256 "5c3bd7c14167b388e1efc05e8a45c693a2ca056e56d5a069fee7bfd0c6168dac"
  license "Apache-2.0"
  head "https:github.comapachepulsar.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24087d099b3a27f15fd36c09819324c0aea461f8b62974243ccff6c57efdf4b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fae3916aeb26d157911c426c4788d146bd186478b7303f75f9b29201a98232f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69543f45f1f046c14bf922faf625a714848b5f972b75dbef5648413a016b387b"
    sha256 cellar: :any_skip_relocation, sonoma:        "729047245e954df7b6d41eb30574c6402e9d74e336e228b2ebc641e3ab8cd379"
    sha256 cellar: :any_skip_relocation, ventura:       "7a6565081a8924b667354a9685f17a3833ba8cdf08f653355cff2b13d92ebbf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee90bb08b934ee8397089852a2b9ea696590bcf2b2676f6fabfc0d0b66cf3d2"
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