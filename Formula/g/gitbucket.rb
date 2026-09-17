class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://gitbucket.github.io/"
  url "https://ghfast.top/https://github.com/gitbucket/gitbucket/releases/download/4.47.1/gitbucket.war"
  sha256 "cabb2d732ccba11d8e48cd9b7a8a4dcc374def998bbcf03c79bd97ada17b0c1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43ae1132070f2e977de61bca64c984b95da44a47a366d8f87d308e17dc723e94"
  end

  head do
    url "https://github.com/gitbucket/gitbucket.git", branch: "master"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "sbt", "executable"
      libexec.install "target/executable/gitbucket.war"
    else
      libexec.install "gitbucket.war"
    end
  end

  def caveats
    <<~EOS
      Note: When using `brew services` the port will be 8080.
    EOS
  end

  service do
    run [
      formula_opt_bin("openjdk")/"java",
      "-Dmail.smtp.starttls.enable=true",
      "-jar",
      opt_libexec/"gitbucket.war",
      "--host=127.0.0.1",
      "--port=8080",
    ]
  end

  test do
    java = formula_opt_bin("openjdk")/"java"
    fork do
      $stdout.reopen(testpath/"output")
      exec "#{java} -jar #{libexec}/gitbucket.war --port=#{free_port}"
    end
    sleep 12
    refute_match "Exception", File.read("output")
  end
end