class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.8.tar.gz"
  sha256 "d558ec8df5e6f4d164f7fd88c90de8c61cf7bf72e8c1c37e483a06f3bd84648e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a467ac0dd014e9f4790d628a3658f0839821e27bbda6babd6110e3968af0b605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4891d24d9a4c71eb2fbf9eba8327fe61f75649eca77b423efb0cf44d020aee6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db4273012438f651e979667b27bc663ba57ecfb8439c73f958b8fce07985abe0"
    sha256 cellar: :any_skip_relocation, ventura:        "dfd9b44a0673ccc58c70e9bfec3e38224ad0eac3a9b0adce0ba7d173a4110532"
    sha256 cellar: :any_skip_relocation, monterey:       "233439fd78ec106f5e19269df37a946c90e0f713a5efffbab4823e82702b40dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b6e79cc443ab4811f1c9a4bbf798b051cf31f673c0d8fb82217f0c9b9645020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb63e80dde447191e128194905023d9c3bd3d58efbd4ed36bbd7a31b9b17b131"
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