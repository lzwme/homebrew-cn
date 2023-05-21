class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v3.9.2.tar.gz"
  sha256 "1b05428c99a0dd496924bd72b3124cc3758027bf60a676ddf50bd29dd45e44fa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee9c1f91743aea8b631aaf5fc4e17f7b745a441e035dcf1bb0afbb918feb1af3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a32bf6464ec037a07e5b6b82478511bcf0518db26235816aa093a651a2351639"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40bad750194061164511ec33dd13943775a3f8d9ab3f43ad59092323f211373e"
    sha256 cellar: :any_skip_relocation, ventura:        "83e1099d20c54af1febe13f41d9a61c9e3ad8cc0471f0846c0ddd5eef4b850d7"
    sha256 cellar: :any_skip_relocation, monterey:       "1f06e07ec2d33b7e62ad53460a4abc620b70c817f4c334cd1f5853ca0728dddc"
    sha256 cellar: :any_skip_relocation, big_sur:        "18368a2aa2df46d8ce1fdf5904aa18595332f232cd22401a10a4c6af56594a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "013de923b6fa2f5462e6451d89f47d5a4e3a63e9c61902525101b1c10d14394e"
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