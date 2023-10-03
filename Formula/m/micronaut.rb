class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "8567f340f6bef432a734ab7a3b6170f9aaee7764fe8a520e875607ba5fc96085"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de4caab7cdc3b223751fa93f3b42fd288fe70fe3a944620ec03c359df594ab30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "081ad32748fa9b82556d7e6bebb4a3089693dd606be6d5bd75e8414d2b97ebe0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91f20d6b9ded7e2c1fcf2c83d2f6c4849022a33325676b08b03c29fe38d86dca"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e53a3e0f1bcce5be4d31bda32111f9e6a00318226cde1897de5f75cf3e7cc37"
    sha256 cellar: :any_skip_relocation, ventura:        "89981d1219ee229afa89791e0d3a135228c200ac0615f295fe48ac9a918bea50"
    sha256 cellar: :any_skip_relocation, monterey:       "11ce0fe4ee6106f915ec07efffb03fa39ba954f463b474b29552ad0ac378ba67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84aead7f5a6a52d36bd79a34dc6008b0e1190b46ecd31fd41f8e7f922758b43d"
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