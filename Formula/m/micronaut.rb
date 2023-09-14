class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "8d6f01c87898d9c523c4d9e695825eee6c3e7ae7f7ce0df7d8181b7c9cf640e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a43154da425ae2ed7611b75e7c193e02d7a22cb1acfee70b987ecde47dc06f54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ffde302e6c231c99118dcbdb6f9ec4935bd18322b8b14e4edac19f8bc40aab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8ca9eac3fd42be4b0e7bbd1fbb1743d368511cba1732d0b89ceb2735719d3ae"
    sha256 cellar: :any_skip_relocation, ventura:        "58362bad34d9a691f356f742237a04b76adc5131877476b6c16d7889ae824add"
    sha256 cellar: :any_skip_relocation, monterey:       "fadf36458da68e094bdf6042ef3161b0383df11010ebfce7b3c464e433753696"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f4d7e6e95cd427a985be63e31bfae06280eb19f5b72be1db596679fa3b3ab78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be0ec5c8896217dea20511ee027d6716aefac32c55d2fbd13cb3777c959f116f"
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