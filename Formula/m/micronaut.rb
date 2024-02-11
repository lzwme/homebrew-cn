class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.3.1.tar.gz"
  sha256 "326d1a2d2c22b21acc49a670ea9f0860aad8d14d0317492b35493d508643224a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05a8f101fc5fcea92247998eef597bd4e0e8f6c7bd2fe9cdaa17b2fdcd16343c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "891d343a3e164cef2f55b3e44b92f1f16084ad3e302a33cc3f1174b87225207b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb45a6a2e07a8bce981d50931e530dc35845f2b5de4f44b56ad0dc16e5429ad3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e6dc993fa534236385d1f44716e76ec185d90ed5a91f7350ed48325a242c077"
    sha256 cellar: :any_skip_relocation, ventura:        "adc5aba542b4d22882623c7ee57da7735679b1fe4e5a981011db88a7d71c5dca"
    sha256 cellar: :any_skip_relocation, monterey:       "2c17d15ad2577ef54e253f961f9011201c979eef112c12f10593fb6c580fcf21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82462623114618af7f47da4182ceb5b1b6785d34059e127b5313cdef44d7955a"
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