class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.7.2.tar.gz"
  sha256 "c547932619b5aba7bc752356125b424ae444e620844c6c834a2dff74713e35c7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f36f49dd7380a933fcf897f21e7aae29c411a25dfbafe30ce195f9acdb4f9684"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6baa6734500374513357f8366372374a673802126eedbbf48816054932fb76fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e8ee006cfddaeef70d258eddf14b8f38acc31079420550d5377e298f2225d10"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c5aaa5d02f82c1fb1cf6795d91a6df9ba3ca28cbf1c4aab6ec152ca4266b5c3"
    sha256 cellar: :any_skip_relocation, ventura:       "94fed0711af32e4320eca468356da78c243cf5d97de6835de962dff4166eedbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c47561a1e88b22995c7564ad6478950a5f5beb50082ac3b9f629ee6a060bd3"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-clibuildexplodedlib"
    (libexec"bin").install "starter-clibuildexplodedbinmn"

    bash_completion.install "starter-clibuildexplodedbinmn_completion" => "mn"
    (bin"mn").write_env_script libexec"binmn", Language::Java.overridable_java_home_env("21")
  end

  test do
    system bin"mn", "create-app", "hello-world"
    assert_predicate testpath"hello-world", :directory?
  end
end