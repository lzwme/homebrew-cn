class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.3.0.tar.gz"
  sha256 "1cdb838f679163e2759e05e423bf0f30c932205aea2910496bf29b3bb523c06a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cce0f024117e0de2269eec006baef13f464a61511a0cdb8aaaaa7ea819e42cc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "715a7360fb920676a0243bbb6cb5a4399217c188f458900afeec4db2b1528ebe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10ffbaf33310768b4f0b321347b5c8752d391768ba906f04c8ab155d3eedc30d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5084aaafaffb9e2983f38baa8026817853fe4abffa163588671f2b8a583b18af"
    sha256 cellar: :any_skip_relocation, ventura:        "deee7aa59df3f24ec802ee62eb19c5ba8b6e3ef9ade96a3679657962f620820e"
    sha256 cellar: :any_skip_relocation, monterey:       "48dd6226849c1f3c89e4e6dfa9ba924c4a9679461f149d5ec83ce93386f74517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "998477ee133c96fcdcc67d187d07a22569047d69dcf7ff9ef07959d4cbbe50ee"
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