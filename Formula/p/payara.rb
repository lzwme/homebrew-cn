class Payara < Formula
  desc "Java EE application server forked from GlassFish"
  homepage "https://www.payara.fish"
  url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/6.2024.6/payara-6.2024.6.zip"
  sha256 "01b70d244cc6933f659875a21d65ef6b5dee293fe22de5b9c9288b7b78d6eba3"
  license any_of: [
    "CDDL-1.1",
    { "GPL-2.0-only" => { with: "Classpath-exception-2.0" } },
  ]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df95de99b77d0a4d330814417b634448e62ce9778934cf6d1b993c4d2abc224d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "252168875fba6cf58b444f9f259c8ee58a14bfbfbc4d54d4ff7c2bf92d01e12f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "252168875fba6cf58b444f9f259c8ee58a14bfbfbc4d54d4ff7c2bf92d01e12f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fe3e6588e75e724dd96f00a0b08fbb26c9a82fec6fe11c5d522f313a12fa5f6"
    sha256 cellar: :any_skip_relocation, ventura:        "2fe3e6588e75e724dd96f00a0b08fbb26c9a82fec6fe11c5d522f313a12fa5f6"
    sha256 cellar: :any_skip_relocation, monterey:       "41642982377d5f4b1b2a9a1dd2bdde6c03f385122384e11e461a5c764c63940d"
  end

  depends_on :macos # The test fails on Linux.
  depends_on "openjdk"

  conflicts_with "glassfish", because: "both install the same scripts"

  def install
    # Remove Windows scripts
    rm_f Dir["**/*.{bat,exe}"]

    inreplace "bin/asadmin", /AS_INSTALL=.*/,
                             "AS_INSTALL=#{libexec}/glassfish"

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
  end

  def caveats
    <<~EOS
      You may want to add the following to your .bash_profile:
        export GLASSFISH_HOME=#{opt_libexec}/glassfish
        export PATH=${PATH}:${GLASSFISH_HOME}/bin
    EOS
  end

  service do
    run [opt_libexec/"glassfish/bin/asadmin", "start-domain", "--verbose", "domain1"]
    keep_alive true
    working_dir opt_libexec/"glassfish"
    environment_variables GLASSFISH_HOME: opt_libexec/"glassfish"
  end

  test do
    ENV["GLASSFISH_HOME"] = opt_libexec/"glassfish"
    output = shell_output("#{bin}/asadmin list-domains")
    assert_match "domain1 not running", output
    assert_match "Command list-domains executed successfully.", output
  end
end