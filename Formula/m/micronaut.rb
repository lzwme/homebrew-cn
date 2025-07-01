class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.9.0.tar.gz"
  sha256 "8116048981461d6a702f447f01b33d0a2b3527567b0aab33aece694d56c34e8d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e423e6c0d50599a6285e5c3f15487f3fb6f2e1e35b9e31d369da132d11a7673a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5050a5e1e3115ce8c5fb095323dd5b030a64d6424534c33fb8b20acb5fbb73be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ddd8465cb4e4541ab7c41a6a5262788031a252149b3be4c1fe5f6f068af745a"
    sha256 cellar: :any_skip_relocation, sonoma:        "38db2e1881497add47589310b8e0fc2c9b12a5cc1913571a867a74fbfeec0df2"
    sha256 cellar: :any_skip_relocation, ventura:       "630e76084c807bb8dfd7093ad2315c67283f15148a381388bd37c99e1c4096a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f330e8777270a697ad762c576fd3d37e51e08d7f1f058a12f55a5fcbdad0e2f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "709dc3d22e87524c14da04a4e4a0f7565e5f6d809a94d18f6ca2c6017c19a39e"
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