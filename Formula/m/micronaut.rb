class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "192e3ad84bf66e49aad9e875a512e302afcc4662aaf859f0a537632d85faf6a8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "798887a3f795c27f41c60ee51cc5403ff73f2f6267f7063d5ca203d51b64fc76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c92513625cba42f3992b68ee86fae86e1e6e06454448a0af891d9c9690a672d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d174f51b6db8b7944aaadb337e89a53c5177d426ae5baf15a1ce2d059fac651"
    sha256 cellar: :any_skip_relocation, sonoma:         "48e87d175f2ab805ece39d123f83b0257d804bc0f6e3dc708faceea0f8690b80"
    sha256 cellar: :any_skip_relocation, ventura:        "67a65c3d602e98ee8019366329c8cffce59d934e392b1e0e976b046243e2db09"
    sha256 cellar: :any_skip_relocation, monterey:       "0cd9c36ae21e816d633437054943bd61e38bd4a1b5a14b006beb1a305a788a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea6a713542e415f470e4ab95d6e8a235ef9a16f78aa4af0b2272e003566ac4e9"
  end

  depends_on "gradle" => :build
  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end