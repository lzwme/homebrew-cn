class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v4.0.2.tar.gz"
  sha256 "e678a41acf09110b98f20e16d3e480dba89854d31be675ef1e74730e067c8682"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a4eb2e092fc2c2c2942d7a9c6dfb4784c33c9d2aae5580cefd3bf09589edec2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eaa111b1e91edbfefae6035e4ab70b2ba34c48d2603d86161c09c04f6f16e2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12043806478b7ed081e0692e96cc88498d051f6ce45c1a91318748fabd170055"
    sha256 cellar: :any_skip_relocation, ventura:        "8e86b5cf97ebf12a89cb0e9f99b9f1199178a119f51fe3f2000a4beebac7c5db"
    sha256 cellar: :any_skip_relocation, monterey:       "da8518ab3fabbffa528fd7780b392aa9e28ef4e286c7b12da1f0e5f9ce6fd072"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c30838f57b3e9d9e017127301233af4e198fe3f9547559e230534a737f8d4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c246ddd0a4706d6f985319a4fc68e588a238523d6dc1e529d3351e823cf8c2"
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