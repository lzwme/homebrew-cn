class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https:github.comtickstepaliyunpan"
  url "https:github.comtickstepaliyunpanarchiverefstagsv0.2.9.tar.gz"
  sha256 "f714fcf1886c0f887f9ed1230004e9bd98bd97a01063f34f42f33b2c252512f7"
  license "Apache-2.0"
  head "https:github.comtickstepaliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44778c5944c178076b418027f1cc4698b3c9b303e25787b8a692f64cb8ae5414"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b83d5068deab3d30668d2795ba556fe83b55e62c720bc21f5f25e2dea594b45a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf1989b4dd91aa5562e9a10500441ffbe949d50c5fa6bd7dace3823aad3e75b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "adce8ba69659a522d90fffab2254afd066eddfdd5d9055deb1ef342f9ca08fdc"
    sha256 cellar: :any_skip_relocation, ventura:        "401312b80b41a0725e64a0013bc75a66377b00f8447fb656794c1ec534e6e934"
    sha256 cellar: :any_skip_relocation, monterey:       "8259c82061a631d7d5551f4622c4c523a738dabd54cbc0d52796510da8b11b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b947def3fae943b2b5ff7e963ef2c95b14f08793b118d4cf2a0e169c7a8c5e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"aliyunpan", "run", "touch", "output.txt"
    assert_predicate testpath"output.txt", :exist?
  end
end