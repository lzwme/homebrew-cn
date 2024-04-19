class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.4.0.tar.gz"
  sha256 "fc0b7eb6ab3c0e0dbae257e4b5a3c34e04aa835d152bf0211d7b466f4e3dcde4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32b2fd5205d03107a409f9588f24d669523acc63e137075abe70caf6f6a186ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd11432fab27b47fb9cf479859afe0393908cdbf01910a5f896b29b2a130d38c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8cd28bd4349ce98e27a7f56f939124d9ec98401f647679915e629416251e8cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "21517cb5b2befd02804dc2958f582fcb324e62af2e45184b87e68299dc6c2871"
    sha256 cellar: :any_skip_relocation, ventura:        "1dbfe36f1eeaa8b2f19b4f4fd2e98d6a4538ee5036f743a7e7c12f487e52a04a"
    sha256 cellar: :any_skip_relocation, monterey:       "76d55fbf5bb0e914e107044fd64a29d375821ef8615d4b96d5c52eeab909bf28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26810d013c60a22f0dbed349a9078851698bbd5987c42307c0a90859c1bd4973"
  end

  depends_on "gradle" => :build
  # jdk21 support issue, https:github.commicronaut-projectsmicronaut-coreissues10046
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-clibuildexplodedlib"
    (libexec"bin").install "starter-clibuildexplodedbinmn"

    bash_completion.install "starter-clibuildexplodedbinmn_completion" => "mn"
    (bin"mn").write_env_script libexec"binmn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}mn", "create-app", "hello-world"
    assert_predicate testpath"hello-world", :directory?
  end
end