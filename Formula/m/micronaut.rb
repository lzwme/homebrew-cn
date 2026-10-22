class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.2.3.tar.gz"
  sha256 "c0b9dd0f636a2405c4cb2bb6fea6a53a998d4905b7fb5afe5fc15f080a8e98e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9c8ac400b311a58b22bf3b5913962404398fe07bb200015fd146dc6fa7bdbee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9c8ac400b311a58b22bf3b5913962404398fe07bb200015fd146dc6fa7bdbee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9c8ac400b311a58b22bf3b5913962404398fe07bb200015fd146dc6fa7bdbee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1629f1928e6e7214a513dc923a4028e25908f106ea8a29c893664dfb5ba94f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1629f1928e6e7214a513dc923a4028e25908f106ea8a29c893664dfb5ba94f72"
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