class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.5.tar.gz"
  sha256 "0aa8ae7268a0809449c6e9f6c90c685143ef89d96916ff9e25a71553b3c18a0b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb530c9113342e72251f8689af3bf046811f69b757e8fd26875b9f4645c25c25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81c39afef813b371793abd9f70fdb6477cfdc950f6e1e34e39792cab06e42d97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4321fb6d06b080181bb6794650583fccd5da4f8d2eb2dd93e85456d4805e47"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8187d20de8ca64fc08fb3e1de2091397999d5e0f7e24827bf115aa76c31380f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ee5e2ed24a3c4808f7bdb6f996c4fbe3dd80be373d46f1a2655ca503bcd72b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a32835bdbd1e2e9838f56aa2b67ccb03d25b539d6b5a0ddeb3d1392859211af0"
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