class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "9f5d05f953d357d709fc5f2ee0f3a36fe928ee5216fe553c75038a2d97c6c5f2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "165b4baaaa2042888bb26554728570e24ccffb5425159eae3675ee078da703ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f090aa1f07d34abe2c44b1f409a95b8348403c16d9936c628c8d0708228abe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcb8a88c9315106af0e9e8d3ca6563a2629c1a2d84eaf7887894fd0480d793ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3c01c51af02dba9df948ebe5f75897fe95590c7ff78c62c9b6da6ce1d7bdaef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffd77a76c458b6102240eed2c12df12ff9f96b0c6736fab4f9dcae6ddd94b911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8af292d5f949734902b2c4ec098c9fc0b05efcf4db9d5605519bf723739f26db"
  end

  # Issue ref: https://github.com/micronaut-projects/micronaut-starter/issues/2848
  depends_on "gradle@8" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("21")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end