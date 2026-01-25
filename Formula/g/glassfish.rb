class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.org/"
  url "https://download.eclipse.org/ee4j/glassfish/glassfish-7.1.0.zip"
  mirror "https://ghfast.top/https://github.com/eclipse-ee4j/glassfish/releases/download/7.1.0/glassfish-7.1.0.zip"
  sha256 "67ee62ecaaa6799eadddec0a3872422af99bf07e3fa70be101a510ab25d6746d"
  license "EPL-2.0"

  livecheck do
    url "https://download.eclipse.org/ee4j/glassfish/"
    regex(/href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "930d7e8538c87988d908d5c214948045538903ad29083b5b7a6d959d2c4dd331"
  end

  depends_on "openjdk"

  conflicts_with "payara", because: "both install the same scripts"

  def install
    # Remove all windows files
    rm_r(Dir["bin/*.bat", "glassfish/bin/*.bat"])

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")

    env = Language::Java.overridable_java_home_env
    env["GLASSFISH_HOME"] = libexec
    bin.env_script_all_files libexec/"bin", env

    File.open(libexec/"glassfish/config/asenv.conf", "a") do |file|
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

    cp_r libexec/"glassfish/domains", testpath
    inreplace testpath/"domains/domain1/config/domain.xml", "port=\"4848\"", "port=\"#{port}\""

    spawn bin/"asadmin", "start-domain", "--domaindir=#{testpath}/domains", "domain1"

    output = shell_output("curl --silent --retry 5 --retry-connrefused -X GET localhost:#{port}")
    assert_match "GlassFish Server", output

    assert_match version.to_s, shell_output("#{bin}/asadmin version")
  end
end