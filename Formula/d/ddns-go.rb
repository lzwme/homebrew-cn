class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.6.2.tar.gz"
  sha256 "2e4910d5c0854f98e782a8cdc97d630ee0138de41a3b98d0ada588b1007337f3"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13162e6b4539d15809878962f1dc3cb8877176e772b43c2c6d09f0b780c5c7bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d92e2df2f346c0838aac6b92487bc81d1e3c9ad1ef2c1ef66f7429dad21bb25d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46b63cb676c6bf0838d71e5d7b339556227151ff910422b10a60c034e7689c78"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a940aaa566d5414ffd7d4a1ffac0bf54bd240745e63c5d0c242067772bb34d5"
    sha256 cellar: :any_skip_relocation, ventura:        "b414ae08ac1851aaa41b7adf6b5e3c5b9e6e2271e0b8c6dde8cd64bf671bd0e3"
    sha256 cellar: :any_skip_relocation, monterey:       "25ed4bd0247733ae102638b9ade713d45726b6325d80b9697f85bdd9aa2b0e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c31c150c2821d91747d2ccd7fe7e751cc4c8e084d2bf0263bc0c4c1314a0b29"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ddns-go -v")

    port = free_port
    spawn "#{bin}ddns-go -l :#{port} -c #{testpath}ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}clearLog"
    output = shell_output("curl --silent localhost:#{port}logs")
    assert_match "Temporary Redirect", output
  end
end