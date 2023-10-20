class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.1.5.tar.gz"
  sha256 "59d8c074fcdf9f98ad27df52107ef60f85a185f3eaa1d6a6bf097acb4282fc83"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "518e71edbb33d327cf1234bf8d891ce92dafb99c6fe04b5c5d8460e95f4b97a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "554a9fce41f84833deaf38069e7c8d55d4ecd9fb63eeace885b18dd35f0d66c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51ce91cac0261a96957cae4aa9affd23c4a38e816272739c5950a2486f2db162"
    sha256 cellar: :any_skip_relocation, sonoma:         "bafd38c87ea8fd87923c2a6eed07daa958b55c98ed18ca7eb4b8405d963edeeb"
    sha256 cellar: :any_skip_relocation, ventura:        "e698fac4a90dd63a57a15036f711bc5088083b6c64cf51cf92072eb3e4f842e4"
    sha256 cellar: :any_skip_relocation, monterey:       "58ac2539376f4f17d0b33d8b2cb2870b4a31a27cf620ab7aeb947f0aebb941b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77c187422883071a5d857a9877c90a9f3da189c59867cc71702c7e5eeb8ac571"
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