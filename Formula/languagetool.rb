class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.0",
      revision: "e44dbb08fb820b622e6639c8877d1f240c3f638e"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e94268e46fd9a0a001c855dbc00f2e587500402e4aee4dbdb94393192b0ac26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f1d47cd942c138fc11fcd970dd761f59ddae34b203746285dfced9b2f44ca75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77029a607129545ce00dc766d9bbc71c4c277a47020c8acf63885b77732fb05f"
    sha256 cellar: :any_skip_relocation, ventura:        "dc46ea4e847850e466ae444e5cfc2b42500a17fe14a612cc9a541edfaa8746b1"
    sha256 cellar: :any_skip_relocation, monterey:       "7f60ac5f015348ca22386b4d08969882e21357efe2150788dbeb9f17af543246"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e7995c3081e984420641a7ea25d21a03dadeca5d9d2d47d4dad201d896cd0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "200948cb33c554c3d38139e23ea4c4d2765aba3a0f904f4824683a05dd787ac3"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    java_version = "11"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    system "mvn", "clean", "package", "-DskipTests"

    # We need to strip one path level from the distribution zipball,
    # so extract it into a temporary directory then install it.
    mktemp "zip" do
      system "unzip", Dir["#{buildpath}/languagetool-standalone/target/*.zip"].first, "-d", "."
      libexec.install Dir["*/*"]
    end

    bin.write_jar_script libexec/"languagetool-commandline.jar", "languagetool", java_version: java_version
    bin.write_jar_script libexec/"languagetool.jar", "languagetool-gui", java_version: java_version
    (bin/"languagetool-server").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env(java_version)[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec}/languagetool-server.jar" org.languagetool.server.HTTPServer "$@"
    EOS
  end

  service do
    run [bin/"languagetool-server", "--port", "8081", "--allow-origin"]
    keep_alive true
    log_path var/"log/languagetool/languagetool-server.log"
    error_log_path var/"log/languagetool/languagetool-server.log"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Homebrew, this is an test
    EOS
    output = shell_output("#{bin}/languagetool -l en-US test.txt 2>&1")
    assert_match(/Message: Use \Wa\W instead of \Wan\W/, output)
  end
end