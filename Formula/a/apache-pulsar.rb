class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https:pulsar.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=pulsarpulsar-4.0.0apache-pulsar-4.0.0-src.tar.gz"
  mirror "https:archive.apache.orgdistpulsarpulsar-4.0.0apache-pulsar-4.0.0-src.tar.gz"
  sha256 "5c3bd7c14167b388e1efc05e8a45c693a2ca056e56d5a069fee7bfd0c6168dac"
  license "Apache-2.0"
  head "https:github.comapachepulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "3cbd5ddae480d01655634e38431c8e11aa3b7e244b494b8361aa192cfcbb8a07"
    sha256 cellar: :any_skip_relocation, ventura:      "3d2b2c2b5753c72152a76c6aab6ab28dc9947ef9038590ff72fe70e2f476e2e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c0847ca767f80ff5405fa975a3cedec0001f4476ee6be3903f55537cd26d1d3f"
  end

  depends_on "maven" => :build
  depends_on arch: :x86_64 # https:github.comgrpcgrpc-javaissues7690
  depends_on "openjdk@21"

  def install
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
    sleep 45

    output = shell_output("#{bin}pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end