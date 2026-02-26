class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.9.tar.gz"
  sha256 "b2d97d809c9a7dc0911e0a5d34f401eecf29a72eb43d275aa7dd768deea4abf7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15d63b0d12e5722a1a1390519cfd20a9335c377d4ca6818242f598e639fd728e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a74722b799445b4b5a0090f5c25e4f543e6199fface5eaebaa18ffc774b172a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccaf013ec7ba38683173bc1bed5261ad4dfa595bd264d7a8860a79a36890afde"
    sha256 cellar: :any_skip_relocation, sonoma:        "b13c26ae4df26dc5dad65dd3151f61677873f2df559e27860613e7171165d91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "575eda9d1f4a190d0aad667d7c65da5f2a3f22337a9dd291727252ba636cd407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486d5621a6d11fd7aa5861d8503b21e393b79f6281b224c15adb5ca93747ac8c"
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