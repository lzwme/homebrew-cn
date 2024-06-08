class Zfind < Formula
  desc "Search for files (even inside tarzip7zrar) using a SQL-WHERE filter"
  homepage "https:github.comlaktakzfind"
  url "https:github.comlaktakzfindarchiverefstagsv0.4.0.tar.gz"
  sha256 "dcec50de9c343e6b1b7a8651d0c49753700ea85159c26e0524f8bf827d111e3a"
  license "MIT"
  head "https:github.comlaktakzfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "267584b6bc410820891625566c6aeebcd8aeb61eb55daeb0e95b1b3cdeebfb02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e676f48cff623db1eace7124501c439c8fbf9a39b8bb308f68811c60d1ca23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bf4c527c7314db0eac8a1ad41fe35cdc55e9b228970c1b5e1f5211dee96e830"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0be8544749dc05e86fabbdda4fc61d3e95c4623f904a4b491c42c8333bf0bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "a0c0e90666e6f3e3de4e53a00f2b6e3ada951beaf748ae6ebb0252f39386ea5a"
    sha256 cellar: :any_skip_relocation, monterey:       "52b9406e2ff701db51d3761fc8e29d7926b15bab1aed081493c2c0fcb168f535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6287c556e695a96633a95a1838e901fc7201b081b1831e2354da559db086e6c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdzfind"
  end

  test do
    output = shell_output("#{bin}zfind --csv")
    assert_match "name,path,container,size,date,time,type,archive", output

    assert_match version.to_s, shell_output("#{bin}zfind --version")
  end
end