class JvmMon < Formula
  desc "Console-based JVM monitoring"
  homepage "https:github.comajermakovicsjvm-mon"
  url "https:github.comajermakovicsjvm-monreleasesdownload0.3jvm-mon-0.3.tar.gz"
  sha256 "9b5dd3d280cb52b6e2a9a491451da2ee41c65c770002adadb61b02aa6690c940"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "88c2a99416c6bd4c33480769b5e47f9f4964d28d0f04fbcb1821e2fda0e891b7"
    sha256 cellar: :any_skip_relocation, ventura:      "c20d541a04a08a0282c90ed1968fbc03d5be5012f9a73e22b52d2ded67c9a880"
    sha256 cellar: :any_skip_relocation, monterey:     "c20d541a04a08a0282c90ed1968fbc03d5be5012f9a73e22b52d2ded67c9a880"
    sha256 cellar: :any_skip_relocation, big_sur:      "c20d541a04a08a0282c90ed1968fbc03d5be5012f9a73e22b52d2ded67c9a880"
    sha256 cellar: :any_skip_relocation, catalina:     "c20d541a04a08a0282c90ed1968fbc03d5be5012f9a73e22b52d2ded67c9a880"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0c83187b28705971793ac3f89c385a07edd958d20d3d30e0c133b77bc5fc0ac0"
  end

  depends_on "openjdk@8"

  def install
    rm(Dir["bin*.bat"])
    libexec.install Dir["*"]

    (bin"jvm-mon").write_env_script libexec"binjvm-mon", Language::Java.java_home_env("1.8")
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Duser.home=#{testpath}"
    system "echo q | #{bin}jvm-mon"
  end
end