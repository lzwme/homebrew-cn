class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.112.0.tar.gz"
  sha256 "e4cba31aa92e8de1dbabc470224582cc617ece5238db69ec1c544f05072429a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cfadc59ad1368fd1e167b15b094a893af16a77877d72fb68ecff219d0481332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4db51ea639ce8dff3c1c1fe38e3794ceb145ae9c1678ab07fa5e58c4251addae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a0efd40853fb9125f78afbf6f8f2b729e96dfcbd1266e284d534c8e35c8415"
    sha256 cellar: :any_skip_relocation, sonoma:        "326b7f227048d93250a367debc21358ca66b4f17e25f982b79c6cb5782482747"
    sha256 cellar: :any,                 arm64_linux:   "20d563ab9eec688b83f2b5ccf640ac41d9a6e318f1b45cc9aa51292f96aa6f1c"
    sha256 cellar: :any,                 x86_64_linux:  "4f9ab5b2f1169638090a6aaac253a8f6716b8c9914e468d43eb937c3a4a3b783"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end