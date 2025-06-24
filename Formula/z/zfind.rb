class Zfind < Formula
  desc "Search for files (even inside tarzip7zrar) using a SQL-WHERE filter"
  homepage "https:github.comlaktakzfind"
  url "https:github.comlaktakzfindarchiverefstagsv0.4.7.tar.gz"
  sha256 "49bc01da8446c8a97182f9794032d851614f0efc75b4f4810a114491a08d3bd4"
  license "MIT"
  head "https:github.comlaktakzfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42a14d6e1ee0eb40c0309c893b877c1e7440796eaf7209db195c576362f096e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42a14d6e1ee0eb40c0309c893b877c1e7440796eaf7209db195c576362f096e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42a14d6e1ee0eb40c0309c893b877c1e7440796eaf7209db195c576362f096e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f91bac0d8be49b7de9c64e288c9e8ce3430202d7fa6f258255fa97242dc52786"
    sha256 cellar: :any_skip_relocation, ventura:       "f91bac0d8be49b7de9c64e288c9e8ce3430202d7fa6f258255fa97242dc52786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f07a3ba2af17209191e615c27b235be99fc748fba24f932b15d6005b588a6fb"
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