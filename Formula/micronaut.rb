class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/v4.0.0.tar.gz"
  sha256 "8fdf2345c986b54a34dd176c9fe7279cb22e34bc4271ee25921be17dbc17ef52"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2821bf41107928f18c5e2c2d62de082b7ddbf08c28afbc1a6e47e7e695fd3d03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1bf6e7dac189c328c056e065e3681e18fb7effd59bba34d681c5d9cbb1789be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35b8fba828e6e2d5b0598963b7b6ef4bf5e4ee551417a3c6e1624274ae77cbab"
    sha256 cellar: :any_skip_relocation, ventura:        "7e67a3b8e6a8c2816441710bba4746898bd86ece732fd15998a3a1ed34c0dd5b"
    sha256 cellar: :any_skip_relocation, monterey:       "36e866443ae4da285ca87296ca2066ae8c9e3c5f010ad74fd7fde9d6651905be"
    sha256 cellar: :any_skip_relocation, big_sur:        "64721e59a7bf0d0296c893ec103f2e66d7268d97016a303ddb064702ead636df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0cd06650ccb7f373be4c10e96943eaceddaca22f1c29db10cb634d6a6a758ff"
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