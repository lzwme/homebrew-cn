class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.9.tar.gz"
  sha256 "885fe78ef3804907f07bd15ab3ed904fb15f8fb5f09302871bb59b416cbe5309"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59f9ab03da45aa472211ac2cb6aa9e9877a4b7594dbebef3868d3cb2897cd548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d16c1441316b2ce33952ce384fea9c7d43b0f85a3bbea7dd29f4c63d760543f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "947dc549f84370013a096fd1e24773a2d367b613a43339537d29a7e1728b3ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "49d9232b759bae438ef44f35d2903a069ccbc64f11ffed079cec75f130c06edc"
    sha256 cellar: :any_skip_relocation, monterey:       "a7d4ad0c5549d9982d811601435011e88a166fc71228d74b1ecc8fc2fb99f924"
    sha256 cellar: :any_skip_relocation, big_sur:        "985634c88593e22816ffd90e153ca99f6d20379d32b5e6199caac17cc6ce09e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b944a6df49f7e8e9be23e52f041fd5f0ebe113eede998a182fe539a7512f4e3"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@17"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end