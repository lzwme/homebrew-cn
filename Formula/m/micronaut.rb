class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "b49b26e57932edc75f91f8f888b6886e70d5dd0583a07d3d95c12db9af67eab4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27104f7f25e981dd811246c814028540fc80e61c7b9476d6ced60b36dedac6f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27104f7f25e981dd811246c814028540fc80e61c7b9476d6ced60b36dedac6f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27104f7f25e981dd811246c814028540fc80e61c7b9476d6ced60b36dedac6f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0eed6148831042ab28dd068dca8fac3872903c1c0df836826aae358cabf779ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0eed6148831042ab28dd068dca8fac3872903c1c0df836826aae358cabf779ac"
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