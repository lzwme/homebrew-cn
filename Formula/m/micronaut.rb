class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "fb6b62b5f204e194b160eab8a2c3c43c860574b441fdbede87f13ceaef63bdc5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e181976653c76b0f87ff574a42cb6924c254f14506407bcb4324a1e92039765"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cffe8ece263b25e64cc84ff5a7d82eb07f04e2d56b16b51e3641254fbcefc317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb0b5aa05bd0df5c7fd2122f6f6c521e6a1b6753f8bb15c9ebde5f32d24f14a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b875d93f046ec4e087e6b9fd2cd8cd4d79739143a0395eea2dab78f0a07cf023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ecd98cc1396ac7cd3fd4dd20e96a249c02320ed868f76ca741656d56b99a8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d3917e01e94c1ad6cc4d1bbe8c8d57b1990a430f45ace9e42d5f2a0d41ea4e7"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("25")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end