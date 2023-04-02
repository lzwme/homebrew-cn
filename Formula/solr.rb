class Solr < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org/"
  url "https://dlcdn.apache.org/solr/solr/9.2.0/solr-9.2.0.tgz"
  mirror "https://archive.apache.org/dist/solr/solr/9.2.0/solr-9.2.0.tgz"
  sha256 "8b134a13a3e7598f68565b01e755a47e24b37a88141cd2f489fc2812c96f21af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e3ef873e5f986f860403a75246b71871b54ce06d8fd712c250f4f6a8d7e7490"
  end

  depends_on "openjdk"

  # Fix Java version detection.
  # Extracted from commit below; commit contains changelog updates that can't be applied.
  # https://github.com/apache/solr/commit/f7fe594cdadeadd1e0061075a55a529793e72462.patch?full_index=1
  patch :DATA

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.md", "server/solr/solr.xml", "server/solr/zoo.cfg"
    prefix.install "licenses", "modules", "server"
    bin.install "bin/solr", "bin/post"

    env = Language::Java.overridable_java_home_env
    env["SOLR_HOME"] = "${SOLR_HOME:-#{var}/lib/solr}"
    env["SOLR_LOGS_DIR"] = "${SOLR_LOGS_DIR:-#{var}/log/solr}"
    env["SOLR_PID_DIR"] = "${SOLR_PID_DIR:-#{var}/run/solr}"
    bin.env_script_all_files libexec, env

    inreplace libexec/"solr", "/usr/local/share/solr", pkgshare
  end

  def post_install
    (var/"run/solr").mkpath
    (var/"log/solr").mkpath
  end

  service do
    run [opt_bin/"solr", "start", "-f", "-s", HOMEBREW_PREFIX/"var/lib/solr"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["SOLR_PID_DIR"] = testpath
    port = free_port

    # Info detects no Solr node => exit code 3
    shell_output(bin/"solr -i", 3)
    # Start a Solr node => exit code 0
    shell_output(bin/"solr start -p #{port} -Djava.io.tmpdir=/tmp")
    # Info detects a Solr node => exit code 0
    shell_output(bin/"solr -i")
    # Impossible to start a second Solr node on the same port => exit code 1
    shell_output(bin/"solr start -p #{port}", 1)
    # Stop a Solr node => exit code 0
    # Exit code is 1 without init process in a docker container
    shell_output(bin/"solr stop -p #{port}", (OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]) ? 1 : 0)
    # No Solr node left to stop => exit code 1
    shell_output(bin/"solr stop -p #{port}", 1)
  end
end

__END__
--- a/bin/solr
+++ b/bin/solr
@@ -163,7 +163,7 @@ if [[ $? -ne 0 ]] ; then
   echo >&2 "${PATH}"
   exit 1
 else
-  JAVA_VER_NUM=$(echo "$JAVA_VER" | head -1 | awk -F '"' '/version/ {print $2}' | sed -e's/^1\.//' | sed -e's/[._-].*$//')
+  JAVA_VER_NUM=$(echo "$JAVA_VER" | grep -v '_OPTIONS' | head -1 | awk -F '"' '/version/ {print $2}' | sed -e's/^1\.//' | sed -e's/[._-].*$//')
   if [[ "$JAVA_VER_NUM" -lt "$JAVA_VER_REQ" ]] ; then
     echo >&2 "Your current version of Java is too old to run this version of Solr."
     echo >&2 "We found major version $JAVA_VER_NUM, using command '${JAVA} -version', with response:"