class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "2e77e9207d9b26cfdacb21744fbd76b9394258b54f83e6d29db47e7fc36a2f74"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "146bb4aa2642308952989b0ad6c64a18f34f26c8ebed2fbfe60ba98f00a2946f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2de7834d1761be6af1577b81c516152a6079c6afacb04002c5dc6999fbeb14a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d4b513f7e7c4bef20019f645dec96acc078663e9ca303b91dfe53f419c6b9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "589e4e5cee4b6c7edf453d1b16121fff695f49266ec9419e01a8af4b87927ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ec2c9b5286549395fdf1be3c7d5cdf685485b540403e2ce650fcb5903d2b8f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "028c55920f42186fd784972f28e36dd0f0b4b6dec1b2b0df90fb97c41bb56ede"
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