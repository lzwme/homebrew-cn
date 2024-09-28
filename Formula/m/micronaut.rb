class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.6.2.tar.gz"
  sha256 "a6ef143c51f7a69a551e8dc164236df4e65b966a9e1136475a20d1314e9812f2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3990dacaa787f473cd308344eebc4abf462ba9368d593bf395c8a8ab09cd83d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "598fc7419e882fb87a2b8f01f5598ce407524495df44211dd78767721d06aeb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08e25069de93990360a839e0ff18591d41f5383a5e1afb7f13fe41c9b20f6d70"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ea1ee3030ba63fe34d8e595dd50ac9db224f84e65c2fff9e33f3f25d122aa7"
    sha256 cellar: :any_skip_relocation, ventura:       "e06dbf796f92c9cf8c2f0ce65ae8bb84123ef5f65425c1c5c10dc7a4201d9261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d8bda38a9e1b8221adff379fb1d044089c581ea591317c002673d53c718e9c6"
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