class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.4.3.tar.gz"
  sha256 "f64fced09c77031f61cc43cbcd26d0870b0d5e1d7bef4c6c4e39b77fdfd829e8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae51553f04a2956f1196876dc35f9d9cd0d5709c051623a15141c62729d05584"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbdfb8d370a765f2181d02d5b267963e333f08547c3a6476938c89e857b68f53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c451d1acee58af2fc8c8713d3c6b089a65de4ff174126eaf31ae419ca493c96"
    sha256 cellar: :any_skip_relocation, sonoma:         "08d02dfdc8066fbaa3b78713bf61e6943ebc6b96938a1c816e28a471481e07a9"
    sha256 cellar: :any_skip_relocation, ventura:        "a46963d6a4d57caa58a279ede3b5813715bb7c6fd9151a03c60815fa01f9dfd1"
    sha256 cellar: :any_skip_relocation, monterey:       "6c7b7d75844caa4e44441e743b891eba8a37c4ccca58831eee3898795f081a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72ca5a899adf37945d4e2f575a15b8d719f84eacaef5d2759364eb74aa0c6612"
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
    system "#{bin}mn", "create-app", "hello-world"
    assert_predicate testpath"hello-world", :directory?
  end
end