class Glassfish < Formula
  desc "Java EE application server"
  homepage "https:glassfish.org"
  url "https:download.eclipse.orgee4jglassfishglassfish-7.0.16.zip"
  mirror "https:github.comeclipse-ee4jglassfishreleasesdownload7.0.16glassfish-7.0.16.zip"
  sha256 "0a0457780b7fe23c2c302394355a2dd0d2087fcd641386e37344988cffe72b8b"
  license "EPL-2.0"

  livecheck do
    url "https:projects.eclipse.orgprojectsee4j.glassfishdownloads"
    regex(href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zipi)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0446d3579a1c34792baa033c3779a4b65276ca8fe23ce9d3a18baeb86acb2973"
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