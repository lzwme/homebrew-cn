class Solr < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https:solr.apache.org"
  url "https:dlcdn.apache.orgsolrsolr9.8.1solr-9.8.1.tgz"
  mirror "https:archive.apache.orgdistsolrsolr9.8.1solr-9.8.1.tgz"
  sha256 "a789110131bc8cb71b0233d528e4fa5ffa566bab05bc72f280a8cc9275bd9e3e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1b1b9d9f35f77d275fa2686314998b9a97036b69ecd18fa2e562da1c317150d7"
  end

  # Can be updated after https:github.comapachesolrpull3153
  depends_on "openjdk@21"

  def install
    pkgshare.install "binsolr.in.sh"
    (var"libsolr").install "serversolrREADME.md", "serversolrsolr.xml", "serversolrzoo.cfg"
    prefix.install "licenses", "modules", "server"
    bin.install "binsolr", "binpost"

    env = Language::Java.overridable_java_home_env
    env["SOLR_HOME"] = "${SOLR_HOME:-#{var}libsolr}"
    env["SOLR_LOGS_DIR"] = "${SOLR_LOGS_DIR:-#{var}logsolr}"
    env["SOLR_PID_DIR"] = "${SOLR_PID_DIR:-#{var}runsolr}"
    bin.env_script_all_files libexec, env

    inreplace libexec"solr", "usrlocalsharesolr", pkgshare
  end

  def post_install
    (var"runsolr").mkpath
    (var"logsolr").mkpath
  end

  service do
    run [opt_bin"solr", "start", "-f", "-s", HOMEBREW_PREFIX"varlibsolr"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["SOLR_PID_DIR"] = testpath
    port = free_port

    assert_match "No Solr nodes are running", shell_output("#{bin}solr status")

    # Start a Solr node => exit code 0
    shell_output("#{bin}solr start -p #{port} -Djava.io.tmpdir=tmp")
    assert_match(Solr process \d+ running on port #{port}, shell_output("#{bin}solr status"))

    # Impossible to start a second Solr node on the same port => exit code 1
    shell_output("#{bin}solr start -p #{port}", 1)
    # Stop a Solr node => exit code 0
    # Exit code is 1 without init process in a docker container
    shell_output("#{bin}solr stop -p #{port}", (OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]) ? 1 : 0)
    # No Solr node left to stop => exit code 1
    shell_output("#{bin}solr stop -p #{port}", 1)
  end
end