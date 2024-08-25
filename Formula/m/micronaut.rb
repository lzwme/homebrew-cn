class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.6.0.tar.gz"
  sha256 "29e5a2b9f0a45642ecb07bfd0f34a5d40b44fdbf9ca889dc4315a2ceb9788239"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ad3fe2d971bb83df5d2a89063cd56083f4c7ffce68b67a613cd0473f6ecb93e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ff1639016e02d5cd863df555d2177929096f0bdda08186c325021946a72b6a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2804d72a41184580846b2b99d1d0999dec81d4b828de7eeb16c1650b01a46b7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6306366b22589c6d72bc0f505d94f30cc38384c221ac5c6ff2c6da2fae8733b"
    sha256 cellar: :any_skip_relocation, ventura:        "06dee177dc33e64f966b167713b00b906cb472add0a09a96cbf977c17e29a33c"
    sha256 cellar: :any_skip_relocation, monterey:       "767520216340e7f765eb613c9820d681d68141adb5cade161764cfa4bdf5be62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d0e3aae378ae4b82e747bec29b2362ae75e4c70d439b60d0d528242f2d2398"
  end

  depends_on "gradle" => :build
  # jdk21 support issue, https:github.commicronaut-projectsmicronaut-coreissues10046
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-clibuildexplodedlib"
    (libexec"bin").install "starter-clibuildexplodedbinmn"

    bash_completion.install "starter-clibuildexplodedbinmn_completion" => "mn"
    (bin"mn").write_env_script libexec"binmn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system bin"mn", "create-app", "hello-world"
    assert_predicate testpath"hello-world", :directory?
  end
end