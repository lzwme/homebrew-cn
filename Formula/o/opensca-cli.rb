class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https:opensca.xmirror.cn"
  url "https:github.comXmirrorSecurityOpenSCA-cliarchiverefstagsv3.0.0.tar.gz"
  sha256 "65633f9a76e00a218abc9f71a487cc1bb93a8951885915bd05337ebbaec52884"
  license "Apache-2.0"
  head "https:github.comXmirrorSecurityOpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c8f1c4758080385aace1b5f3c29ce37fe1e550c3b293304eb06ac86546a55da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fa23298b50f435b6be3f15e38c745288d536b3a5234f435d4dc2fb14ef9e54e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f6694ba7a4ee2a521f73cf05256a949fefb9186d3b521badd44d44ef5ce2769"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb1f45f4d31c71ae6daa4956f843c4c86bd13420d4e628faaf862168cc878b86"
    sha256 cellar: :any_skip_relocation, ventura:        "eea39c4662ea4d4185fcbf42ca435c232e4fa5eefe8b6c91f89175adf7cd5137"
    sha256 cellar: :any_skip_relocation, monterey:       "0d224a5a69310cde08ae498425426fe14137b9bf8b9e5af1e20492606a61002a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a8fee3ea602858e1fbdf921d6cf7230af4f7921b5a27b1b671073119dc64b49"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin"opensca-cli", "-path", testpath
    assert_predicate testpath"opensca.log", :exist?
    assert_match version.to_s, shell_output(bin"opensca-cli -version")
  end
end