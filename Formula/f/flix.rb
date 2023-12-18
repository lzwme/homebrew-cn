class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.42.0.tar.gz"
  sha256 "e112648588b669f4b3b92eee51455dfd491e20501104313d62f3af6cb91b4f2e"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7308688d468c6f7baa4231b6e3b901c2004e1c05360993bbcd6bcae321c241a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "255a0db470bb1fa2eeccd1987d86f8a8b9e43e781b7ef9a8fcb2015ee384e4e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "febfe093ec0afee6dd5521c0414cbdef00c96bc73bacf4cef42f34a861a9bad3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d9b1f403d24db21575b5b6891400854efa1a920c7b6c8defd86298c772f7bce"
    sha256 cellar: :any_skip_relocation, ventura:        "6a15e3b4abcc8d83acf04370562a452cbc6ac93faf5cbe94117d36118c729bc8"
    sha256 cellar: :any_skip_relocation, monterey:       "0785c862eb825f5ff54d9905696acb861469bcb31516bdcc383713e64411030b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83dd84d2f1830a8eda3b9de150cbc6af5ae8795874391efae9114d57f858cc6d"
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