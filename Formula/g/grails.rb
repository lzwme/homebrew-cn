class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.apache.org/"
  url "https://ghfast.top/https://github.com/apache/grails-core/releases/download/v7.2.4/apache-grails-7.2.4-bin.zip"
  sha256 "5cbbd4ec69b25c3711075a426dc69945ba2c597f0c07a9ac31615ecd47d29050"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c798c7f6af302ad08f2a37e1c9fa7e7dc83f10b6c525280e15727f75205767d0"
  end

  depends_on "openjdk@21"

  def java_version
    "21"
  end

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", Language::Java.java_home_env(java_version)
  end

  def caveats
    <<~EOS
      The GRAILS_HOME directory is:
        #{opt_libexec}
    EOS
  end

  test do
    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails --version")

    system bin/"grails", "create-app", "brew-test"
    assert_path_exists testpath/"brew-test/gradle.properties"
    assert_match "brew.test", File.read(testpath/"brew-test/build.gradle")

    cd "brew-test" do
      system bin/"grails", "create-controller", "greeting"
      rm "grails-app/controllers/brew/test/GreetingController.groovy"
      Pathname("grails-app/controllers/brew/test/GreetingController.groovy").write <<~GROOVY
        package brew.test
        class GreetingController {
            def index() {
                render "Hello Homebrew"
            }
        }
      GROOVY

      # Test that scripts are compatible with OpenJDK version
      port = free_port
      ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
      system "./gradlew", "--no-daemon", "assemble"
      pid = spawn "./gradlew", "--no-daemon", "bootRun", "-Dgrails.server.port=#{port}"
      begin
        sleep 20
        assert_equal "Hello Homebrew", shell_output("curl --silent http://localhost:#{port}/greeting/index")
      ensure
        Process.kill "TERM", pid
        Process.wait pid
      end
    end
  end
end