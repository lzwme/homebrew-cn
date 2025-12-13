class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.4.tar.gz"
  sha256 "445ce7344099f767228efa6fb72ea7be47e6f7ab1296c366ed866415f43e5d8f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa29a76acc843dcd875a71505431aa1a6847134c47f96e97b963d4a6d8040009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74b7bb36c765126697593c206fd068c25662ebda7db58e328258a6b33be55078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "279e91a6f6a8d40ff7a925b7eaca517607e21ef121fcb6983c1f3ab8b589e51f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb3cacd8f656b45d6616856cadf076939b3f49b03d56ebe285997312bb0ee4e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c97d2517ddf9264d7148d271a2d28c05f38533a227d5b83c5bb6bf3188b98cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae8db4283ea7d9140ab0a2abfadb211d64d0417b5969baeaabbdf6722aeef9b"
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