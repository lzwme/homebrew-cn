class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.8.3.tar.gz"
  sha256 "8b6052a9d4fc228333a3226ed060ea544730fb0af3e2f65475dffede252574a5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56ead464feb56f2a60b1f171f23a3cb795bc79de46b237faef95b53e079ff48d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8793b71825c928e524bec3dd4812d55b4eeff67bcb3c8820765a3cae2bc9772a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a8e4f522cc206e9a7fc5264483d38bc3e8ad85aae11f76dccf8f55eda33fc57"
    sha256 cellar: :any_skip_relocation, sonoma:        "51bdc2a4bab3beb1239a89d3f174725e2619de09031720d86dcbe9668bfac305"
    sha256 cellar: :any_skip_relocation, ventura:       "4b1ed11027d930add9d7330b16ee5b658241febf30b12f53f0a13530b4170853"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb025e18565af7d5b30bea3732002c3b87be30b4bd0aefc4fac631ab17e62a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "274c461a2edb480c72997e9e2735eeb4c4b075213aceb00bad68bfce9209dc53"
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