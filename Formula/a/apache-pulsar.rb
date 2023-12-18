class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https:pulsar.apache.org"
  url "https:www.apache.orgdynmirrorsmirrors.cgi?action=download&filename=pulsarpulsar-2.10.3apache-pulsar-2.10.3-src.tar.gz"
  mirror "https:archive.apache.orgdistpulsarpulsar-2.10.3apache-pulsar-2.10.3-src.tar.gz"
  sha256 "4fca38025c6059b0cb1b8c8ca7526a6c525769529c270a0172e2294d311b8f96"
  license "Apache-2.0"
  head "https:github.comapachepulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "52af44a4b2da0f8c9d740a777f5832178671c57d3575626fb64cf91c6cd2dd04"
    sha256 cellar: :any_skip_relocation, ventura:      "b2cb224fda738665fbc52ed1d5453a92029f93634e8595c7e12d6c53bf379127"
    sha256 cellar: :any_skip_relocation, monterey:     "e5da9cdecab9c6174a03dc5d1b762fe618fc305956432e37397a56413f0ef3f0"
    sha256 cellar: :any_skip_relocation, big_sur:      "7bf2487edb3e1bb850c57407c06970869dc827bc45c0a91640c0de46b5592855"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1d05c070af32efa5ad73ab95ce541f8d701fdfbb5f4c24647c42fb13ee91c6b3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on arch: :x86_64
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
    libexec.install "#{binpfx}bin", "#{binpfx}lib", "#{binpfx}instances", "#{binpfx}conf"
    (libexec"libprestobinprocnameLinux-ppc64le").rmtree
    pkgshare.install "#{binpfx}examples", "#{binpfx}licenses"
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
    fork do
      exec bin"pulsar", "standalone", "--zookeeper-dir", "#{testpath}zk", " --bookkeeper-dir", "#{testpath}bk"
    end
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 15

    output = shell_output("#{bin}pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end