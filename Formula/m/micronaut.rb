class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.7.0.tar.gz"
  sha256 "ea6fb188f0f2c495e586413a3c80abfccc9aa9f391bb0b98a64367c43e5c6549"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ee8b06b780e80a6df147c7ddc09c0277181b818e3161c37d14d22310e6ea879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1e558b5461b98b3ecdb0672523db340fc5a6d3a79549604a815aafbd198b43a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51e75ee65d5c6e93e8dd4e8e5be66fc2b327a2f124ad77c692ead00efc781cad"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d477e346c048397cfeaf2d2077378b5ffa3cbefbd6316caa1e2e3837481955f"
    sha256 cellar: :any_skip_relocation, ventura:       "48a468df4fc0879690827c828613df63052a62103011cef301a494a0ea0b9a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15a0848dd9725935d72b9619eede2869f774f216617faba098935b1c1c543e39"
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