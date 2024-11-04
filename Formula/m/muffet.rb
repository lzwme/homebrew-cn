class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https:github.comraviqqemuffet"
  url "https:github.comraviqqemuffetarchiverefstagsv2.10.6.tar.gz"
  sha256 "8da1668efd6c53e0a0eff584fdc49c591fa9684cd07c5c4154114549157f72d1"
  license "MIT"
  head "https:github.comraviqqemuffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed2f4492e254d460defef6238fb4323f4de77dca59405d1308ceb808d0a29fd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed2f4492e254d460defef6238fb4323f4de77dca59405d1308ceb808d0a29fd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed2f4492e254d460defef6238fb4323f4de77dca59405d1308ceb808d0a29fd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aed3e5c717e5aa52ece626e0887410a13c358a709b5efd1d9e4b93a63724648"
    sha256 cellar: :any_skip_relocation, ventura:       "3aed3e5c717e5aa52ece626e0887410a13c358a709b5efd1d9e4b93a63724648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e93e735b6070dd39bcd3bf21298d0932dab0936545a6b29d4e7e7662eb55415"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(failed to fetch root page: lookup does\.not\.exist.*: no such host,
                 shell_output("#{bin}muffet https:does.not.exist 2>&1", 1))

    assert_match "https:example.com",
                 shell_output("#{bin}muffet https:example.com 2>&1", 1)
  end
end