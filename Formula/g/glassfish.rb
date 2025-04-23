class Glassfish < Formula
  desc "Java EE application server"
  homepage "https:glassfish.org"
  url "https:download.eclipse.orgee4jglassfishglassfish-7.0.24.zip"
  mirror "https:github.comeclipse-ee4jglassfishreleasesdownload7.0.24glassfish-7.0.24.zip"
  sha256 "03609a3cdef90946a617adccf66e1fb5777e8ac4ba11dd8f4085036ba35c5ba4"
  license "EPL-2.0"

  livecheck do
    url "https:projects.eclipse.orgprojectsee4j.glassfishdownloads"
    regex(href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zipi)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "779bc9dceabcdf02f586a963f4fb7c5f89965ed1087a32c562288def13e11fa3"
  end

  # no java 22 support for glassfish 7.x
  # https:github.comeclipse-ee4jglassfishblobmasterdocswebsitesrcmainresourcesdownload.md
  depends_on "openjdk@21"

  conflicts_with "payara", because: "both install the same scripts"

  def install
    # Remove all windows files
    rm_r(Dir["bin*.bat", "glassfishbin*.bat"])

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}bin*"]

    env = Language::Java.overridable_java_home_env("21")
    env["GLASSFISH_HOME"] = libexec
    bin.env_script_all_files libexec"bin", env

    File.open(libexec"glassfishconfigasenv.conf", "a") do |file|
      file.puts "AS_JAVA=\"#{env[:JAVA_HOME]}\""
    end
  end

  def caveats
    <<~EOS
      You may want to add the following to your .bash_profile:
        export GLASSFISH_HOME=#{opt_libexec}
    EOS
  end

  test do
    port = free_port
    # `asadmin` needs this to talk to a custom port when running `asadmin version`
    ENV["AS_ADMIN_PORT"] = port.to_s

    cp_r libexec"glassfishdomains", testpath
    inreplace testpath"domainsdomain1configdomain.xml", "port=\"4848\"", "port=\"#{port}\""

    fork do
      exec bin"asadmin", "start-domain", "--domaindir=#{testpath}domains", "domain1"
    end
    sleep 60

    output = shell_output("curl -s -X GET localhost:#{port}")
    assert_match "GlassFish Server", output

    assert_match version.to_s, shell_output("#{bin}asadmin version")
  end
end