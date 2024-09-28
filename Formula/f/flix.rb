class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.51.0.tar.gz"
  sha256 "adb35cb4711cd09df331b67f82388f713bfd1623e3d31ad5868deb53ae416fa6"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1b8b574d4a491b63c2bc9aaf2230ef60576c15835d63ca0860ed1a4d5cd3426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6cc23ee429fed12449085a478c573d3fae5c39892eafbd2fd5825acfae35e2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92c4da02ca510aa96c83ba6cdc6c64307fd5f35a85d3ed5d0d1d6c686dc2e1d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b70843cbb433fcdb042a737ab151ac0137b362dddbfbe72511b5e485de400e31"
    sha256 cellar: :any_skip_relocation, ventura:       "51b22c129d00c602d26e29492d3615a65f5fbede64a9a8b4ce7dda7fa2b89c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bbde6dbb4dde4f89144fc500efca6a690c6fac77c4d6fd552e19f54c3bdd35b"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system Formula["gradle"].bin"gradle", "--no-daemon", "build", "jar"
    prefix.install "buildlibsflix-#{version}.jar"
    bin.write_jar_script prefix"flix-#{version}.jar", "flix", java_version: "21"
  end

  test do
    system bin"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}flix test 2>&1")
  end
end