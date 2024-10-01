class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https:hadoop.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=hadoopcommonhadoop-3.4.0hadoop-3.4.0.tar.gz"
  mirror "https:archive.apache.orgdisthadoopcommonhadoop-3.4.0hadoop-3.4.0.tar.gz"
  sha256 "e311a78480414030f9ec63549a5d685e69e26f207103d9abf21a48b9dd03c86c"
  license "Apache-2.0"

  livecheck do
    url "https:hadoop.apache.orgreleases.html"
    regex(href=.*?hadoop[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "947ff1f70270d1f4028678211dfdf773be119bafcbbf15e4a7f24fe90996fb0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bc4d1af76f0d40746abffa84b42508f1ef53eda3d612b03e5c1f4144bb4826a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bc4d1af76f0d40746abffa84b42508f1ef53eda3d612b03e5c1f4144bb4826a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bc4d1af76f0d40746abffa84b42508f1ef53eda3d612b03e5c1f4144bb4826a"
    sha256 cellar: :any_skip_relocation, sonoma:         "090c88b44a952701c87d753f376e9465571bfdd4fcb4de38c245e217964574da"
    sha256 cellar: :any_skip_relocation, ventura:        "090c88b44a952701c87d753f376e9465571bfdd4fcb4de38c245e217964574da"
    sha256 cellar: :any_skip_relocation, monterey:       "090c88b44a952701c87d753f376e9465571bfdd4fcb4de38c245e217964574da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc4d1af76f0d40746abffa84b42508f1ef53eda3d612b03e5c1f4144bb4826a"
  end

  # WARNING: Check https:cwiki.apache.orgconfluencedisplayHADOOPHadoop+Java+Versions before updating JDK version
  depends_on "openjdk@11"

  conflicts_with "corepack", because: "both install `yarn` binaries"
  conflicts_with "yarn", because: "both install `yarn` binaries"

  def install
    rm(Dir["bin*.cmd", "sbin*.cmd", "libexec*.cmd", "etchadoop*.cmd"])
    rm ["bincontainer-executor", "binoom-listener", "bintest-container-executor"]
    libexec.install %w[bin sbin libexec share etc]

    hadoop_env = Language::Java.overridable_java_home_env("11")
    hadoop_env[:HADOOP_LOG_DIR] = var"hadoop"

    (libexec"bin").each_child do |path|
      (binFile.basename(path)).write_env_script path, hadoop_env
    end
    (libexec"sbin").each_child do |path|
      (sbinFile.basename(path)).write_env_script path, hadoop_env
    end
    libexec.glob("libexec*.sh").each do |path|
      (libexecFile.basename(path)).write_env_script path, hadoop_env
    end

    # Temporary fix until https:github.comHomebrewbrewpull4512 is fixed
    chmod 0755, libexec.glob("*.sh")
  end

  test do
    system bin"hadoop", "fs", "-ls"

    # Test if resource manager can start successfully
    port = free_port
    classpaths = %w[
      etchadoop
      sharehadoopcommonlib*
      sharehadoopcommon*
      sharehadoophdfs
      sharehadoophdfslib*
      sharehadoophdfs*
      sharehadoopmapreduce*
      sharehadoopyarn
      sharehadoopyarnlib*
      sharehadoopyarn*
      sharehadoopyarntimelineservice*
      sharehadoopyarntimelineservicelib*
    ].map { |path| libexecpath }

    pid = Process.spawn({
      "JAVA_HOME" => Language::Java.java_home("11"),
      "CLASSPATH" => classpaths.join(":"),
    }, Formula["openjdk@11"].opt_bin"java", "org.apache.hadoop.yarn.server.resourcemanager.ResourceManager",
                                             "-Dyarn.resourcemanager.webapp.address=127.0.0.1:#{port}")
    sleep 15

    Process.getpgid pid
    system "curl", "http:127.0.0.1:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end