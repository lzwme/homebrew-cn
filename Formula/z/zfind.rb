class Zfind < Formula
  desc "Search for files (even inside tarzip7zrar) using a SQL-WHERE filter"
  homepage "https:github.comlaktakzfind"
  url "https:github.comlaktakzfindarchiverefstagsv0.4.2.tar.gz"
  sha256 "767a0b61605ca63be8ebfca19b56ccded2e9ed22920d6d31db3f4b723ed56f43"
  license "MIT"
  head "https:github.comlaktakzfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c689b84b617b0777f55f4e4d56c3f76c9f09a9fdb408526f232d766508c8f60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5279a26326d0c2400f47b2940a372dc07703036dd85ba7875c05f40ffa31a35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "168f671e2d02f8575f345be59f8f0b7701d9edad796bf8361d591f97b270223d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef052695c40b0a9c653c43897b93a31ec7d6bf46bacec53c7afbbaddc877e61b"
    sha256 cellar: :any_skip_relocation, ventura:        "050423c3a15d4d5ad425aeedaf37702d293274b75e68c36d8eed3e80bf2be79b"
    sha256 cellar: :any_skip_relocation, monterey:       "97a9505275b4b1472df29dd34e469edd3b9580b9d88cce31ffb735927ce53510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05a487a536dd37a19d06ba256d1a6f642d2731a17ecde54ba02473557a1e8498"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdzfind"
  end

  test do
    output = shell_output("#{bin}zfind --csv")
    assert_match "name,path,container,size,date,time,ext,ext2,type,archive", output

    assert_match version.to_s, shell_output("#{bin}zfind --version")
  end
end