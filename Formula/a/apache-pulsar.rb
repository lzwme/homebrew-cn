class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https:pulsar.apache.org"
  url "https:www.apache.orgdynmirrorsmirrors.cgi?action=download&filename=pulsarpulsar-3.1.2apache-pulsar-3.1.2-src.tar.gz"
  mirror "https:archive.apache.orgdistpulsarpulsar-3.1.2apache-pulsar-3.1.2-src.tar.gz"
  sha256 "82270fa4c224af7979d6d4689d7a77742eb3a32a32630e052dc93739a35624e2"
  license "Apache-2.0"
  head "https:github.comapachepulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "1422e2ca66e52531d8d6757307e1d051a5a613424380b8f2cc5c2cbc8112d90f"
    sha256 cellar: :any_skip_relocation, ventura:      "db3d30e2d84ccb55eddfdd8989dee651e37bbde90d18491e68d5ca2f7e98ea3a"
    sha256 cellar: :any_skip_relocation, monterey:     "358819b26436b5b5d949a93c5a48644bf90483d6b53e56ab410ea6bba35ebd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1c9adade12d3e3364db1b3f7c1823766845e59ee84f98aa2b78214870c8d4c1c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on arch: :x86_64 # https:github.comapachepulsarissues16639
  depends_on "openjdk@17"

  def install
    with_env("TMPDIR" => buildpath, **Language::Java.java_home_env("17")) do
      system "mvn", "-X", "clean", "package", "-DskipTests", "-Pcore-modules"
    end

    built_version = if build.head?
      # This script does not need any particular version of py3 nor any libs, so both
      # brew-installed python and system python will work.
      Utils.safe_popen_read("python3", "srcget-project-version.py").strip
    else
      version
    end

    binpfx = "apache-pulsar-#{built_version}"
    system "tar", "-xf", "distributionservertarget#{binpfx}-bin.tar.gz"
    libexec.install "#{binpfx}bin", "#{binpfx}lib", "#{binpfx}instances", "#{binpfx}conf", "#{binpfx}trino"
    libexec.glob("bin*.cmd").map(&:unlink)
    (libexec"trinobinprocnameLinux-aarch64").rmtree
    (libexec"trinobinprocnameLinux-ppc64le").rmtree
    pkgshare.install "#{binpfx}examples"
    (etc"pulsar").install_symlink libexec"conf"

    libexec.glob("bin*") do |path|
      if !path.fnmatch?("*common.sh") && !path.directory?
        bin_name = path.basename
        (binbin_name).write_env_script libexec"bin"bin_name, Language::Java.java_home_env("17")
      end
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

    fork do
      exec bin"pulsar", "standalone", "--zookeeper-dir", "#{testpath}zk", " --bookkeeper-dir", "#{testpath}bk"
    end
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 30

    output = shell_output("#{bin}pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end