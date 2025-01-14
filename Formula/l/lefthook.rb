class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.10.4.tar.gz"
  sha256 "89e33e55ba88285a9f8083d12910dcc1144ec06d7c58f51f3f7c53cbc6bb11ad"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d09a1b3334a741813a043c4ad0890500cb6ce775b95e324350be6152c3a519ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d09a1b3334a741813a043c4ad0890500cb6ce775b95e324350be6152c3a519ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d09a1b3334a741813a043c4ad0890500cb6ce775b95e324350be6152c3a519ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "bda953f7414cc513554939acfafc1d55e39157a27edc3748ed637bc318c82c74"
    sha256 cellar: :any_skip_relocation, ventura:       "bda953f7414cc513554939acfafc1d55e39157a27edc3748ed637bc318c82c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c4a78373cbf21e9c3ef098938215ce2061a4cd4358202a3454b47d95f38344f"
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