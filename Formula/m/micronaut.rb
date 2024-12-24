class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.7.3.tar.gz"
  sha256 "5c8c01f87d7834eab830987d65fd073c3d9a1a5196288bb2565834914e77abd6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b208b7586971bcadfa20bb7ee180c5950363130f784d858ae48dec8ac19964a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cae6c116beffe5da195464526af0e19b2883633bc1ffe01a847466caa9944cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be5163a8bd729ac5431b4ccb49102ee5b7f2820ad6c7ea7c9eae97b625181193"
    sha256 cellar: :any_skip_relocation, sonoma:        "315dee15859ed96cb42fd9cf6c5b5947f272d210116222512bcf5304e9d9021d"
    sha256 cellar: :any_skip_relocation, ventura:       "11d2427cb602ab1ef5dc708c13e5d001a1eb2d76e651df69437bd3ae4c4b1a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff154448d78db5743976dc0858586df9e3dbdd5d2b6de281220d045ca4eab4c"
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