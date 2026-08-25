class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "28e7c930ca419c09b947c2d0c33afd96abb425bf2b802a29d0ba0b095833779c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e8dfe8c9474dbcfa6d52213157553ac8416c31765c2fd7a2cab7f12b1aa1dde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cedc2b93095516aa35479cbe10b44c6d4c0c729070c05d00e40792c251b589b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338f54147e94daee03fbd3a240f629038647a9bcd014f30d78dcd9519bcd7697"
    sha256 cellar: :any_skip_relocation, sonoma:        "338fd465cc6f3e4a32fa591ae0ef317312e97a9d93d8563922cda5548af108bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a593c005b6a2c4c973448a02815a69610c557dd32575f8e74951b48ef904a0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbde3fea3b80012236e3b2a76e8a40bd20e65ed78c34d6b51377c744919d5520"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("25")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end