class RestShell < Formula
  desc "Shell to work with Spring HATEOAS-compliant REST resources"
  homepage "https:github.comspring-atticrest-shell"
  url "http:download.gopivotal.comrest-shell1.2.1rest-shell-1.2.1.RELEASE.tar.gz"
  # Specify version explicitly at version bump:
  # version "1.2.1"
  sha256 "0ecfa67d005cc0d51e7a3a26c4dacc53aa12012f0e757332a2fa40c5e780c2d6"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "153d1bc5b10e1be1bb2775eaa53e2eafee9e392489e45082c4db383d468cc041"
  end

  disable! date: "2023-06-19", because: :repo_archived

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    (bin"rest-shell").write_env_script libexec"binrest-shell", Language::Java.overridable_java_home_env("11")
  end

  test do
    pid = Process.spawn(bin"rest-shell")
    sleep(5)
    Process.kill("TERM", pid)
  end
end