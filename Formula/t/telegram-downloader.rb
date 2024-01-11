class TelegramDownloader < Formula
  desc "Telegram Messenger downloadertools written in Golang"
  homepage "https:docs.iyear.metdl"
  url "https:github.comiyeartdlarchiverefstagsv0.14.1.tar.gz"
  sha256 "cc425e67a5bae964acbd0a20a5cbffca046eb6739ae8850ed5d9c949ee2ca1b6"
  license "AGPL-3.0-only"
  head "https:github.comiyeartdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9998c9807fd597bdb56b359b4a21afe533df5a4eb09eb66c811474d7032e3ba4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85e9f9e7f2de0338ab7317e9691a5828e30fa8c673f96fd68ca1c8e61598f60a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95d8f860d770034cb8639c3457ac29f2f985387beb17e4cfd8b979ed8fe95b25"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e95624448d1aa4951311e45d5eb86c2c7d75a3c8f179062a40ab26272dbfaa2"
    sha256 cellar: :any_skip_relocation, ventura:        "93300cb79166dc0b9b6639ff925ffc19845e8aebfe600b8869c838a5d850676c"
    sha256 cellar: :any_skip_relocation, monterey:       "bfe2ec2cf03dba9b75c710a0595cc6eebca3c5b6c17f016dd60e4cc653bd4e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa81ca8dbcced32dfdcbaf82d8198298ff1fe1fbd974b5eb88bbfe68950423f2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comiyeartdlpkgconsts.Version=#{version}
      -X github.comiyeartdlpkgconsts.Commit=#{tap.user}
      -X github.comiyeartdlpkgconsts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"tdl")

    generate_completions_from_executable(bin"tdl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}tdl chat ls -n _test", 1)
  end
end