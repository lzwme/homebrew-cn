class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.10.1.tar.gz"
  sha256 "5dbdd5c68d5872ed7b91c498c3c1824707962a8025c69b735d72d538ed4e8ef1"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdb44fa61a4126004ef38d214a889254d26bd95d0e8bc8b30c7c6e0d13c12f27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdb44fa61a4126004ef38d214a889254d26bd95d0e8bc8b30c7c6e0d13c12f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdb44fa61a4126004ef38d214a889254d26bd95d0e8bc8b30c7c6e0d13c12f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdc0c981f6d90bd5145eabf65988b312800be94519eea60db00f886cfe5f4048"
    sha256 cellar: :any_skip_relocation, ventura:       "fdc0c981f6d90bd5145eabf65988b312800be94519eea60db00f886cfe5f4048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5519e61eb4ff822bcb30b32e6f8bd414b852141340373a9b48fcf47c2d95a6ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end