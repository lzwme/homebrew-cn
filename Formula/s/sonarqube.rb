class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https:www.sonarsource.comproductssonarqube"
  url "https:binaries.sonarsource.comDistributionsonarqubesonarqube-10.4.1.88267.zip"
  sha256 "8163c2a507405b02491c1a3d97c564fb6dc7702b2eb7a0f3b6e7728cd6288207"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https:www.sonarsource.compage-dataproductssonarqubedownloadssuccess-download-community-editionpage-data.json"
    regex(sonarqube[._-]v?(\d+(?:\.\d+)+)\.zipi)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94434460f96aeaae2cff93aff9b7519801a79bceab598acc33eed9914792e98d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94434460f96aeaae2cff93aff9b7519801a79bceab598acc33eed9914792e98d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94434460f96aeaae2cff93aff9b7519801a79bceab598acc33eed9914792e98d"
    sha256 cellar: :any_skip_relocation, sonoma:         "94434460f96aeaae2cff93aff9b7519801a79bceab598acc33eed9914792e98d"
    sha256 cellar: :any_skip_relocation, ventura:        "94434460f96aeaae2cff93aff9b7519801a79bceab598acc33eed9914792e98d"
    sha256 cellar: :any_skip_relocation, monterey:       "94434460f96aeaae2cff93aff9b7519801a79bceab598acc33eed9914792e98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7080d4259d56ecc6946b80ece016f6b9d5853dfbb1738f26f292ede2eb41a52"
  end

  depends_on "openjdk@17"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
    inreplace "confsonar.properties" do |s|
      # Write logdatatemp files outside of installation directory
      s.sub!(^#sonar\.path\.data=.*, "sonar.path.data=#{var}sonarqubedata")
      s.sub!(^#sonar\.path\.logs=.*, "sonar.path.logs=#{var}sonarqubelogs")
      s.sub!(^#sonar\.path\.temp=.*, "sonar.path.temp=#{var}sonarqubetemp")
    end

    libexec.install Dir["*"]
    (libexec"extensionsdownloads").mkpath

    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOMEbin:$PATH"
    env["PIDDIR"] = var"run"
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"
    (bin"sonar").write_env_script libexec"bin"platform"sonar.sh", env
  end

  def post_install
    (var"run").mkpath
    (var"sonarqubelogs").mkpath
  end

  def caveats
    <<~EOS
      Data: #{var}sonarqubedata
      Logs: #{var}sonarqubelogs
      Temp: #{var}sonarqubetemp
    EOS
  end

  service do
    run [opt_bin"sonar", "console"]
    keep_alive true
  end

  test do
    port = free_port
    ENV["SONAR_WEB_PORT"] = port.to_s
    ENV["SONAR_EMBEDDEDDATABASE_PORT"] = free_port.to_s
    ENV["SONAR_SEARCH_PORT"] = free_port.to_s
    ENV["SONAR_PATH_DATA"] = testpath"data"
    ENV["SONAR_PATH_LOGS"] = testpath"logs"
    ENV["SONAR_PATH_TEMP"] = testpath"temp"
    ENV["SONAR_TELEMETRY_ENABLE"] = "false"

    # Sonar uses `ps | grep` to verify server is running, but output is truncated to COLUMNS
    # See https:github.comHomebrewhomebrew-corepull133887#issuecomment-1679907729
    ENV.delete "COLUMNS"

    assert_match(SonarQube.* is not running, shell_output("#{bin}sonar status", 1))
    pid = fork { exec bin"sonar", "console" }
    begin
      sleep 15
      output = shell_output("#{bin}sonar status")
      assert_match(SonarQube is running \([0-9]*?\), output)
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end