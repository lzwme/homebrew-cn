class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.3.tar.gz"
  sha256 "9bb1fc3a629ac688f5f51c01fdec55804c466879f1d4c93c4b193241d1e03562"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26794795777bc9b058aaa3879922d30703b9dbb45e76cb9bb7acf90f662a7f56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9850231c579c7e934d4c020f6c3a045473d9a4afde593888cc653fb492b2e397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b912d6e32fffa42b4a7a4ded586845914d7eb651ee38204aa3392e311f446eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec3396471e893f1a0020ca77c0b976a0cc852affbd64c587e7a1a1ae35f5e203"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e81491238c82b1f4f1c65c9731e2bdf65cb29d683a0fdee40d414dc9271a668b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4802eea8cefeb80d4c9b30b62ce83d0c28d9dfe53c463ddd76bab95422d43234"
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