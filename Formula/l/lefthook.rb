class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.12.tar.gz"
  sha256 "0440305ccee0b911468410f3cd8c4a14714a25a3289bb4ed8d38315fa58d3923"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a03d4b8490f9093d8b3688f2557f15d86ed05226fbe2928c4e99005f3a5c1cc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "066d5ee95f621f0ea35e4a19d421e2be3cc50af618f923f783f496b61f0b1d5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72c50063e55366e17ad2532b66c5b74ff899fcfd868524ccfd0fa54d268b3de2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f91d948df8b7e7e4ed669ab669d145b6c7df54d397fd6ebcaaa2654adbb54b2"
    sha256 cellar: :any_skip_relocation, ventura:        "a35bde970229eef8b33dd92ccbd5da642ea29727c88cab8e2a9031a1a221278e"
    sha256 cellar: :any_skip_relocation, monterey:       "342953d38ecfb7352c3af2324e2d3ad243ed516c8633ef2db607873703355a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0dc1bde98cf0c7842e9430edc229a8bb9b9a708dfe45131fbe0a4f6c3e7b376"
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