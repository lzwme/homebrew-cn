class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.9.2.tar.gz"
  sha256 "2add5f63354e8ea5a76a6ef48dda65a292bcd7e74ebfbaab8bba9322d5d8bcc7"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1afd3bbff53e965ed3519ab1d6f07c216f5b0dd79fd9b37bd1ad6faaca58e22f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1afd3bbff53e965ed3519ab1d6f07c216f5b0dd79fd9b37bd1ad6faaca58e22f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1afd3bbff53e965ed3519ab1d6f07c216f5b0dd79fd9b37bd1ad6faaca58e22f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f04013654274050470f54311284386d709ebe47602701212eeab50ddf226213f"
    sha256 cellar: :any_skip_relocation, ventura:       "f04013654274050470f54311284386d709ebe47602701212eeab50ddf226213f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1866040f3675c16aa6ec02c977926e419f349371a717edf7a1616950a2b64a9a"
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