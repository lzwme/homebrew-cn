class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https:github.comprojectdiscoveryhttpx"
  url "https:github.comprojectdiscoveryhttpxarchiverefstagsv1.6.1.tar.gz"
  sha256 "b9c40677d7aa6cc866970af29d04db63c647e88814a1f36ea5b046bc1846b858"
  license "MIT"
  head "https:github.comprojectdiscoveryhttpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "495681e193c06c703945907f248bf360a04e0454f81f70fe3a820ea1f873d58d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d558fa292bd8c6436f248aeef26d63fc9fd2076b55d158e2968e758b311aa9e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83e2ff44d5c544265d9a7636cf4442f5c0ddc542b398637ff8840a9b58bd0dd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "93bae8c673cafc6a03425651d1605f42ad9d6af1537d366b0e96901208d909b0"
    sha256 cellar: :any_skip_relocation, ventura:        "569c84632b1a26283b0335de170e689f400a02fa200f0585731cc3d216bf87d1"
    sha256 cellar: :any_skip_relocation, monterey:       "d65b6bf8eb0ab09fcad3a42bc2f3cae0348ee1d4ac1004ef2d1d54a13ba97440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe17ad7da368f4ec48daa9a5b577af4537c0454ad1e01e86ab8a3b2955b088c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdhttpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end