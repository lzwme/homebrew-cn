class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v4.0.5.tar.gz"
  sha256 "8ffceff545a2a92dda33137cc288d29bd94ff38189ea52798fe6a2c570e139c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e0be66174ef947406b70f3af1a7fa0746a1a98ca0d33b333f7ebdf3e7b3d5b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4613d93a003e6566e8ee8b618ab295dce9268a7de7f7fc0cf092678dfc095d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4602c6666a630ecbafa85c4be179b2f1221a826cc0919c63a24243f10420f018"
    sha256 cellar: :any_skip_relocation, ventura:        "d305c8477f15472521b35c2e565fdabad1ca527e770f33892f6887f9a04a2af5"
    sha256 cellar: :any_skip_relocation, monterey:       "9933e8ece85d8d6713555746056e998f8de48560e140bda9d60282cf1596aed8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccb27e4f5e309375c1d737e901ea642adacb0e999d1c0bcf78865acaa1d815c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33ac07810ef72b7aaffe6ab62703bec55e67fc24a0a595f8832b690975ea10ef"
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