class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v4.0.6.tar.gz"
  sha256 "2f6bae9bf86cc03d48de4a69731fd987a51c3eb4812c42c8df88b7108f16c838"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d557f99893f2c349e448548cd5310e87d929b9684ba17c37f419460d0c703d3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fe137fd0d15cccc95d24c017c10058f10783dae944640c200d94c2006495ad7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdb4faf3aedc8223ee88cd6972bd044e57750de5413c850c8368bb2491f120d6"
    sha256 cellar: :any_skip_relocation, ventura:        "a79bbdbea9ef4dc1db6f23c59e8f227febe235f42a0a1db22605cfc87b9ba074"
    sha256 cellar: :any_skip_relocation, monterey:       "a5f6b6b6bd4cbf97b878ed8be35d65c8228535a15cbb7e87782103ffb2cf8460"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d3821a1f6d4cfaa1bf336c8dde325036e06f9d13b89d1170c487f9922fd892f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc1ac5b77510d9c3dfa4448f882d8359db271c565aab0f4e0ee31aab9ad9cbd9"
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