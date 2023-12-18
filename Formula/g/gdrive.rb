class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https:github.comglotlabsgdrive"
  url "https:github.comglotlabsgdrivearchiverefstags3.9.0.tar.gz"
  sha256 "a4476480f0cf759f6a7ac475e06f819cbebfe6bb6f1e0038deff1c02597a275a"
  license "MIT"
  head "https:github.comglotlabsgdrive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4561fa71b34e9b35bc364c4804713a764f5670edf4060fe907b288d6e3becbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0966a92b7e068a25e5e0607dc980c99d735f6aaf95df6ec81280e0da0fe9e051"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9899eeeedee1505f99e1b8d56c1556e285d08399fe052abd40ac7256f49438d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bc03621ccea283006cf99f5149c2e12f8184d5a73e8d96d250063d007c94d32"
    sha256 cellar: :any_skip_relocation, ventura:        "fe7e38edb55425f8b6397acfa72d22721685784869605c819229c465daf6e7cc"
    sha256 cellar: :any_skip_relocation, monterey:       "298e93d09b97c5c55f74e707396f731c2cc2176ed45ffe2f79f264b91fa4d42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5db075196c5d95b3353b025e1af49e14bab67cd0e085cc87a098955d38bd4bbc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gdrive version")
    assert_match "Usage: gdrive <COMMAND>", shell_output("#{bin}gdrive 2>&1", 2)
    assert_match "Error: No accounts found", shell_output("#{bin}gdrive account list 2>&1", 1)
  end
end