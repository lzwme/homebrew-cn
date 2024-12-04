class Glassfish < Formula
  desc "Java EE application server"
  homepage "https:glassfish.org"
  url "https:download.eclipse.orgee4jglassfishglassfish-7.0.20.zip"
  mirror "https:github.comeclipse-ee4jglassfishreleasesdownload7.0.20glassfish-7.0.20.zip"
  sha256 "b56c5f2e86a38c822dc3549585d4967ec5a2cbf2becd703ad0d3bbeede9814dc"
  license "EPL-2.0"

  livecheck do
    url "https:projects.eclipse.orgprojectsee4j.glassfishdownloads"
    regex(href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zipi)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3aece59d237464a752b30fcf2d461a566c7ec00eeebe55a3e12154a059a4e4ca"
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