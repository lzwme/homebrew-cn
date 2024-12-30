class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https:github.comgitbucketgitbucket"
  url "https:github.comgitbucketgitbucketreleasesdownload4.42.0gitbucket.war"
  sha256 "f521aba7f220a45c48704d9a653d567f3bf0c4b733e6be8d4eb92c2222cad57b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b8f8475ec42894cf56ffc7adbad5a76aec71c3df33a9d3fcd9346ac97eabef8"
  end

  head do
    url "https:github.comgitbucketgitbucket.git", branch: "master"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "sbt", "executable"
      libexec.install "targetexecutablegitbucket.war"
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
    run [Formula["openjdk"].opt_bin"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec"gitbucket.war",
         "--host=127.0.0.1", "--port=8080"]
  end

  test do
    java = Formula["openjdk"].opt_bin"java"
    fork do
      $stdout.reopen(testpath"output")
      exec "#{java} -jar #{libexec}gitbucket.war --port=#{free_port}"
    end
    sleep 12
    File.read("output").exclude?("Exception")
  end
end