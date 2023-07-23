class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v4.0.1.tar.gz"
  sha256 "886283ba1ab77ee598cfe3cc39b4e1a1af928be48b6424c3d82464c0541a17ef"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79b729a58cb67afd757803d1f026f2c0d65510f1b28b8878f8332dee3e313e99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79b729a58cb67afd757803d1f026f2c0d65510f1b28b8878f8332dee3e313e99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "267c87bd274d8d545f8b1743157f5e9a3fa982bf3ae8fdfda3ab8565d5540783"
    sha256 cellar: :any_skip_relocation, ventura:        "4dbc42d3dcd178052c496ce5fbf28123996793b7c73d0c80b0515267fce03633"
    sha256 cellar: :any_skip_relocation, monterey:       "3a3e0a5729d5acac3e526586b2a9deef346731379b1ad56a5cd966dab8c9dd85"
    sha256 cellar: :any_skip_relocation, big_sur:        "e87dc9271cd44390706447c811d4b399a88e9e49fde29d2f8b8868f259c3d272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bd103fe187d38d8f594d79cd86c9cf262180b52a0b7ccf6af321effb0f4c383"
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