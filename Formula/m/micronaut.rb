class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "fab5eadcd32b24ddda3c3688ed7c3630cf8fd420323dfbd38a0321331242f20d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7c5bcfd931cb990bafdfd12518b594d587675fec286af793717390fbea83672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3e91378b8d85d2a3bfa5b4d603b7e9cde8eab2c2cf1651bf01dd41405d2b04e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a96531b4255d3dd7834273a20b49118186ef46cc34807275581b3c8c72e3bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3fee6686e27cb6efcbed247081faa5e6467f49465aa9ae587956653e7884c45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18cb9e7eeff5234ac3dd4f9f01e4605f0bbbe542b0e897e833e0360f8baaa6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c03a39d5d2599ba8a86770e623a7abc1e8c668ed28efdc4d8617fe239f51cd53"
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