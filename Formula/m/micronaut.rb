class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "9c104e5dee2495f5317385bae0189126e08f9e469edebad85aed1d8e6b6b183f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df234e190078ea4ba99568847d9629f2a736e93d1038855e26c5a106516c0fff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df234e190078ea4ba99568847d9629f2a736e93d1038855e26c5a106516c0fff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df234e190078ea4ba99568847d9629f2a736e93d1038855e26c5a106516c0fff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "651912e502800a587528b82cb0b495afdbc35f5a51e547da38779b1242c9eaa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "651912e502800a587528b82cb0b495afdbc35f5a51e547da38779b1242c9eaa3"
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