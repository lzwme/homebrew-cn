class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.7.1.tar.gz"
  sha256 "83125047e74904c3428ccc1987cd504778ab74415fca7926c81664ebe258f9cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9553a59387938a8204c966fec375c4d69cb03e911632a3ea900ad5f39b9fec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fc357619dbb218184b2874980fa73a82c5df9f78acb7d16c622426f529e28b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ffef001c565b1a3386f2d10826ef53e4ca95440118f23986ca6c4c6eaaeeb18"
    sha256 cellar: :any_skip_relocation, sonoma:        "3149d8cd34a2ec81fc7aa68d514cf6727e2fd8b7da36fa347d8ce13a672aff02"
    sha256 cellar: :any_skip_relocation, ventura:       "c1102ecb961f2ecff994bc44c195fbc154ee702fa74b7ebe454a3ba68219eb3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3635079acd01904275b91e5da32239f4a1fdb4513e2996a6347f8e74da1f7d80"
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