class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https:hadoop.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=hadoopcommonhadoop-3.4.1hadoop-3.4.1.tar.gz"
  mirror "https:archive.apache.orgdisthadoopcommonhadoop-3.4.1hadoop-3.4.1.tar.gz"
  sha256 "9ad5487833996dfe5514e756f4391029c90529fd22e8d002fd3dd0c14c04ba46"
  license "Apache-2.0"

  livecheck do
    url "https:hadoop.apache.orgreleases.html"
    regex(href=.*?hadoop[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f85402488931c97be6c4c8eb13b1c802a417aa79cef03b59a6b294a51c34f261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85402488931c97be6c4c8eb13b1c802a417aa79cef03b59a6b294a51c34f261"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f85402488931c97be6c4c8eb13b1c802a417aa79cef03b59a6b294a51c34f261"
    sha256 cellar: :any_skip_relocation, sonoma:        "a778cfa6e5a611c84fc5ff42e00ad5d568ef7328c41c74a69455b008efcd5221"
    sha256 cellar: :any_skip_relocation, ventura:       "a778cfa6e5a611c84fc5ff42e00ad5d568ef7328c41c74a69455b008efcd5221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95771d9e7f4affc79481feac8b3122762db71f7f508902c18f6751e33ce09838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f85402488931c97be6c4c8eb13b1c802a417aa79cef03b59a6b294a51c34f261"
  end

  # WARNING: Check https:cwiki.apache.orgconfluencedisplayHADOOPHadoop+Java+Versions before updating JDK version
  depends_on "openjdk@11"

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