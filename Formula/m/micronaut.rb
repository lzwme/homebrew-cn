class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.6.tar.gz"
  sha256 "7d6dfae1c467dbe190d4c18438e39ec1bf7d300781e0e2d67dc37cd719d84f00"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "715951d155699b5d9d305fa3272cf55450a15b308ae62c4af973b9582a433d0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97e4f7270d9a694298937091da4bdb1506b22342f98a8de05f821fb501c79fa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae690b8886fdf2a19578f9fd9b28179118088cbc5b13ffabb8f77f04fa7fa692"
    sha256 cellar: :any_skip_relocation, sonoma:        "8daac72f486c9e45d372179f694b3a9404a84700d7801cd33ec43d8711f6b02a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6a3f945aa56c8e0a672998ece4e3a944f87bc9a1e30cea22ef4ff3a542fb188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd28fb22be978fc4c45b0feb6f8ceb4ad76e917d47bbf01d738b183cc158e83"
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