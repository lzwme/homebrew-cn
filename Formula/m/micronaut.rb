class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v4.0.3.tar.gz"
  sha256 "a5bd9c6dad00bc7a371e1afd8e3b3e22d0bf6833f528ab4e3da37b24734dfc6c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "681d1c322fa0a8c8e796a0e396c15c4efe267239435623aba25795f1f3773900"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e02fa500def5ee16eac8267bb99b3b6c2bb87518dff0c1352438ece98b5ebb4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b5190a4c4c944475c689af7eab7bb80db405019bf1b1cb98c48cc24152ecd84"
    sha256 cellar: :any_skip_relocation, ventura:        "7ba1bb40da56b375ba6f64e31907e6a26f0d8bba9a631856f48678e3687dabc1"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a5858523f3afc691b925737c899fb93db069ab6eff0e9564ec5910ac1788f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c03d39d59afeace940a4c8e1480ce08b5eaef51ebfa06ad81e6f93c71f86953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709b46efe5ee9f9c9cb53eb8b21677e8cb0617d1ef0b56dbad50e5e5df2cd3a4"
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