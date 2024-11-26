class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https:github.comVladimirMarkelovttdl"
  url "https:github.comVladimirMarkelovttdlarchiverefstagsv4.6.0.tar.gz"
  sha256 "a40c31d0bfea96652d7d1ea8bf86dd404950a9bde2016873434821d45c6b4512"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2cfdda8f08be45c07a7472c5709987b083eafeea0620aa243fd1b4b52fa985a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "110983a9375d3b25f7b68eed6270a61229bb73c5179572696837e44f024e034c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d4611f1e19a5e334ac499edc3f4156dd7f5b87e195b6436474bbc336a450f2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e33afabd60379ade7c4bd3a1b2bc106ca14c9732bae76637b7989db407128ab"
    sha256 cellar: :any_skip_relocation, ventura:       "064b266342c31ffab041c2499f382687b1ee6957456816a699fc249bd15f891f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d896e26c519ef5c197e2df50796eb7a40dfc1ec1ce88261790e4cd41c26d06c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}ttdl 'add readme due:tomorrow'")
    assert_predicate testpath"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}ttdl list")
  end
end