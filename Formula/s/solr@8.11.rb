class SolrAT811 < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https:solr.apache.org"
  url "https:dlcdn.apache.orglucenesolr8.11.4solr-8.11.4.tgz"
  mirror "https:archive.apache.orgdistlucenesolr8.11.4solr-8.11.4.tgz"
  sha256 "163fbdf246bbd78910bc36c3257ad50cdf31ccc3329a5ef885c23c9ef69e0ebe"
  license "Apache-2.0"

  livecheck do
    url "https:solr.apache.orgdownloads.html"
    regex(href=.*?solr[._-]v?(8\.11(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65d79494d324de0e00931020fc1e1624c7929566a4d66cee0b33052111f6e523"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    pkgshare.install "binsolr.in.sh"
    (var"libsolr").install "serversolrREADME.txt", "serversolrsolr.xml", "serversolrzoo.cfg"
    prefix.install "contrib", "dist", "licenses", "server"
    bin.install "binsolr", "binpost", "binoom_solr.sh"

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
    # Test fails in docker, see https:github.comapachesolrpull250
    # Newset solr version has been fixed, this legacy version will not be patched,
    # so just ignore the test.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["SOLR_PID_DIR"] = testpath

    # Info detects no Solr node => exit code 3
    assert_match "No Solr nodes are running", shell_output("#{bin}solr status", 3)
  end
end