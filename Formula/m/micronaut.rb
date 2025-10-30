class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.1.tar.gz"
  sha256 "bcb2aa6db3542b08d160cad046d40096e2ae2c0dbea846b8bff73513d03055d7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11414f265fe8f27a04e34d3ffff38076099ead6b8f82dbf37ef1ea2fb2a447af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d126a4932d8d74b55017e5454c734ed75e36ee5f6b5c02e1092c2658b910f3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7152eea7daf39cb1fe2a16f6b115faf5cbe2b4e6cb74f92d9baf647c367eeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "033bcbd9c22d7cb9892626d59814f127151ac01393a857b951be29a19d481b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f592e18dc4513eedeed7bb15cdd03cc3ad156ccd733b484bca3038ce5b3cb2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6a7b9346b55c315636dfb96a6a45f8b6dda85856cc11e0e6ca2d3c3fcead883"
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