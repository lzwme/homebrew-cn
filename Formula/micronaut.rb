class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v3.9.1.tar.gz"
  sha256 "e084ebbf505649c010333cc10ca671aa8bbae8c1bbf714cddaaf5ffc1e7437bc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30edf967068b82d4302e5f10cac2ce5e747ea6f378cbf897f42ce1af676e3232"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70be3906521e1de301fed48baece365701cff03a95448c64a289539b4004c87c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c6a7c7e6defae5dc283f308f804ff5732dd4ef3914b63a22d63cd82b0a0d0b2"
    sha256 cellar: :any_skip_relocation, ventura:        "78def039f58e88bfe8c946984320d706302aa7893f4869ac608b5997201d5d32"
    sha256 cellar: :any_skip_relocation, monterey:       "18e7476f7c100476bd7455aea3e78e65c7743cf5f44a9fb0cb40fc787ea4687d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bca19b4a62d6b6b90343dc4e367f3d86f453073216a74992461da0d8dc1dde59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b73bfc59912634c572f62bd04e5b681490842f34a967ee86499fbe5cae2682e2"
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