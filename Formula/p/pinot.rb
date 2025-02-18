class Pinot < Formula
  desc "Realtime distributed OLAP datastore"
  homepage "https:pinot.apache.org"
  url "https:downloads.apache.orgpinotapache-pinot-1.3.0apache-pinot-1.3.0-bin.tar.gz"
  sha256 "9cdc4423187c44569b8c6dd376d0162cc05339f56498a7f3a594303f17e44af0"
  license "Apache-2.0"
  head "https:github.comapachepinot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba258d8e7b33eb25c8b492258d22365260bfd4a60494030559e174309c271219"
  end

  depends_on "openjdk@11"

  def install
    (var"libpinotdata").mkpath

    libexec.install "lib"
    libexec.install "plugins"

    prefix.install "bin"
    bin.env_script_all_files(libexec"bin", Language::Java.java_home_env("11"))
    bin.glob("*.sh").each { |f| mv f, binf.basename(".sh") }
  end

  service do
    run [opt_bin"pinot-admin", "QuickStart", "-type", "BATCH", "-dataDir", var"libpinotdata"]
    keep_alive true
    working_dir var"libpinot"
    log_path var"logpinotpinot_output.log"
    error_log_path var"logpinotpinot_output.log"
  end

  test do
    zkport = free_port
    controller_port = free_port

    zkpid = fork do
      exec "#{opt_bin}pinot-admin",
        "StartZookeeper",
        "-zkPort",
        zkport.to_s
    end

    sleep 10

    controller_pid = fork do
      exec "#{opt_bin}pinot-admin",
        "StartController",
        "-zkAddress",
        "localhost:#{zkport}",
        "-controllerPort",
        controller_port.to_s
    end

    sleep 40

    assert_match("HTTP1.1 200 OK", shell_output("curl -i http:localhost:#{controller_port} 2>&1"))
  ensure
    Process.kill "TERM", controller_pid
    Process.wait controller_pid
    Process.kill "TERM", zkpid
    Process.wait zkpid
  end
end