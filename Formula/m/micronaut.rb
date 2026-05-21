class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "15cf79688caafa1181b365ee484607b44058792313cce6a1939c24f493b41e04"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71bdb90a53b322921ebd1d5ca2cb8d71756a701c6a2a993262ea697e4a131d59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f3460f85dfa9458e663896e257f568a50f25f0ca4cff96f77fbb6f9e33d6d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0caf75a590a4f80fc53495e3417127dc2d7d540216c606e5d8acf2975c411da"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a4e3e9c4439071dc94f708a8cea53663afea3fa2b9066aa43317b14b7d00ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ff0cc505f5aca3de4d0ce34bf23cd38b95947e019bb4e07b3f5605c1238b915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b9fcf4e5c5079056e73e43025055577b23336301288ebd78f440bbd103dc44c"
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