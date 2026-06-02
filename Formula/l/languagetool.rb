class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.8",
      revision: "e807fcde6a6506191e1470744d2345da28c26be6"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(-branch)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0852645061218500b2acc536cdff5f58b3305daea56e790fe361d47e27ff9985"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eca9255a12e1d6b29c0e445236f2ecdac5fd13ea0e60af4bc41063d804260e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca0dde2a879fc3f36eda9229734aa90414c8c5ca69a6b1eee3c1442cf0e1d663"
    sha256 cellar: :any_skip_relocation, sonoma:        "26a949f8abece230c92188b3972fc0b5d26a15ad9480d8174f6324ad1da92b94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "035b4062e1b4cb4698c05b2299f4c73f67cba7f42324d08194339a938d591af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "765c0246dd18db9ab58dd13da1cd5f492b02b42f2dcb0a6755994d0ff3ce5d0b"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    java_version = "17"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    system "mvn", "clean", "package", "-DskipTests"

    # We need to strip one path level from the distribution zipball,
    # so extract it into a temporary directory then install it.
    mktemp "zip" do
      system "unzip", Dir["#{buildpath}/languagetool-standalone/target/*.zip"].first, "-d", "."
      libexec.install Dir["*/*"]
    end

    bin.write_jar_script(libexec/"languagetool-commandline.jar", "languagetool", java_version:)
    bin.write_jar_script(libexec/"languagetool.jar", "languagetool-gui", java_version:)
    (bin/"languagetool-server").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env(java_version)[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec}/languagetool-server.jar" org.languagetool.server.HTTPServer "$@"
    EOS

    touch buildpath/"server.properties"
    pkgetc.install "server.properties"
  end

  post_install_steps do
    mkdir_p "log/languagetool"
  end

  service do
    run [opt_bin/"languagetool-server", "--config", etc/"languagetool/server.properties", "--port", "8081",
         "--allow-origin"]
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