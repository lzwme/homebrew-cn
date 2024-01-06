class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.2.3.tar.gz"
  sha256 "e85ece69bceb60ed7d6c72302f7e2249f6137e8fe145aa7ddcfc2bad0a073b30"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5a8130595e35ccdccb62577d87427a2a5c644dbed6e78b247de250ef512660f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85fb6f1223d38dc14f25afd2f24a5fabc23971b012d8805fbb8653f4101447d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53a81669aab0b923ea5d5409ecdebb88d2d94ec62cbd675b6614dd2148e8d233"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f7e04185ada3199f0e5620b53c76d9f57806e12f74da698d3c0328ee625f9b3"
    sha256 cellar: :any_skip_relocation, ventura:        "50664f764a2c03c36ddfb69b2dd42e68909d42774cd45bdf62cd0c130b44f82f"
    sha256 cellar: :any_skip_relocation, monterey:       "37628f117249b162bf41e222518084c4244a62ff4451ed8877b06583e301ca36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f76ab0defe314f3ce5cf1ee912d0c36df7e991a2a8aceba7729708b204de14"
  end

  depends_on "gradle" => :build
  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
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