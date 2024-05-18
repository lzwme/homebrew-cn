class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https:github.comvultrvultr-cli"
  url "https:github.comvultrvultr-cliarchiverefstagsv3.1.0.tar.gz"
  sha256 "68e4e65a8af3061ca77159dc9d2db61642bbb117f385e2bbe0a5651d9f1ad526"
  license "Apache-2.0"
  head "https:github.comvultrvultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35f570b13a5506144d26cd6a0761fe6ef837c051cf4d119f9d479c8631fc4fca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ff92b7ceb7cca5b9aed5b68761013fd55049eec3f6ab78c4cd6c5347ae54e83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f404d96e7cdca344dbe53969a9b179aa5ffe8aac4697e0fc7f7b2edfa2a7e88"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0a555079e1a16dfd49d032c4fb58a76423b35c2e6989b64d1c290e184332975"
    sha256 cellar: :any_skip_relocation, ventura:        "63ca997ddbbba03816f7e88666b797367bbf31f121dd4d21e66e4b7d83fea373"
    sha256 cellar: :any_skip_relocation, monterey:       "947c474d56451596d2d78f3475e86f4c54a485c2d1673a4d503746b1ca65db86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4994b67ee2c5df3a94139f0641a3350287de2033b8a8b81348cfa44ee99efc12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"vultr", "version"
  end
end