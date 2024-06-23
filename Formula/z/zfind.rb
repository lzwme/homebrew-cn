class Zfind < Formula
  desc "Search for files (even inside tarzip7zrar) using a SQL-WHERE filter"
  homepage "https:github.comlaktakzfind"
  url "https:github.comlaktakzfindarchiverefstagsv0.4.4.tar.gz"
  sha256 "a26b7e4726bb587164d7ff5bb34ad7a84d24af27555fd864bc580f7cc5620a2f"
  license "MIT"
  head "https:github.comlaktakzfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18d818ec6b543da419a0d6a34f7a5f530d14e8738c0595159c2338dd28a2ed42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aba86df95aaec25e62db2cd32d36f98f71970e0593d880bc894845a2dc4f85c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68a63f60cd5e1376dfd3e2510b58185db021e12c6e29c5e7d7c3ed9510910ff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7617b3f1b2650f952e3a3b398d93e0bf35ea53772e736680ebfc31bd00bf1472"
    sha256 cellar: :any_skip_relocation, ventura:        "69d70aba623fb44e10d145216929f59dafe648f45b7b0ff24b86463e29963a84"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0345d6f7e239c97575f881694d2e6dffab1ddaff750ee5f5e5060e8fd8be3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe40cf01b4605da467aef02945672dfe07d830ad2ca1c0a6a03e0db651999bd9"
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