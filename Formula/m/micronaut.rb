class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.6.1.tar.gz"
  sha256 "5c79f85d34a0f6a6c6e62602f1df80d39913219fd2e268463b0449251a049615"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "075643903469076ea06d3193eb6fb290742c365ffc8beea0e69e1827d1e99e54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acf5b2f12b9982fd7b76786850e54cb4dfee37e950813a495a52972cab210b7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dc40594cb52f5b07b067c9e37ab751c9bbdaba6e6b0f79f489a8576bf91f474"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1f5398e5a593268175037c1fa6b9be5c161eb392d98e2284bf9322d5afdafb0"
    sha256 cellar: :any_skip_relocation, ventura:        "44000f751a02a22963f7689da43a4c17862e3dabc81dacccda41a16b879c5856"
    sha256 cellar: :any_skip_relocation, monterey:       "462a867be8f39be1666bef18d26c8b6ae70a98b8bd0f0f8f191bc46333f753a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0b2d421c09d16f3ff2b70f82d43ef4dbbb8aef630cdb4098527bbec62a8532"
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