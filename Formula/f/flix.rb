class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.47.0.tar.gz"
  sha256 "20101818e32245f40a0392c6cda4f89a81d5041c3a0500fc7f0459b1c43a9820"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68a7aa21adf1a1d872c22b6ca9f1051b82f3a677c86162cdaaea2b63b18d7990"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6abfc022ddb88d0c18e6c87acf830fc2dd4785c201e02782cee253de45f74a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d6d4acb3cff04b7c105fb371a53481c65c175a2c0ba8d162293c529a077541"
    sha256 cellar: :any_skip_relocation, sonoma:         "e16493dab207bd7a4df459106b6b6a5e527424c1c3da98df293bdc7f1015a2c3"
    sha256 cellar: :any_skip_relocation, ventura:        "07c7a12f2ec6110f95e83f0a80fe8f2632b0fd28ac70d8ca41819a52c2d42bdb"
    sha256 cellar: :any_skip_relocation, monterey:       "5cd9d6f0982d15599c7830a4e6a17a58fcfeffb434250107ae0ca6d08cf2aa03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed81117b61ee9e88db87860d4a5215d515df011a8b54290dc2e5d65339c13c9e"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    system Formula["gradle"].bin"gradle", "build", "jar"
    prefix.install "buildlibsflix-#{version}.jar"
    bin.write_jar_script prefix"flix-#{version}.jar", "flix"
  end

  test do
    system bin"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}flix test 2>&1")
  end
end