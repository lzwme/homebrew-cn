class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.0.6.tar.gz"
  sha256 "5109f9aa95b1fa8eb62a495db829a0c01b00886a6554512288ed744b0de94c13"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d8a1b1263f685e76a574879ec68c037092bd3c1a4dc9a474c877f2d2422b54e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8885918d755e5e63a2d403259a7b4e0d1478e3ef141724677caa4be30c7105e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23cfba454af9fea83522a1faabd641536a35ba04a93af371c6ffd97e81714a99"
    sha256 cellar: :any_skip_relocation, sonoma:        "99cfcd55886d4873e724566d380c0d9f98d4c0d9ecd384829ea66cc5a062511b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b08b1437d9b5beed21d418ca9471eb26b6275160fe737970d4bb70f472ebb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "925380719e96cea4883451d97389cee156fc05f949f8330df6e91fc5b756654d"
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