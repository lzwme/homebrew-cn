class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https:github.combensadehtailspin"
  url "https:github.combensadehtailspinarchiverefstags5.1.0.tar.gz"
  sha256 "24bdd0e3d44fec2f2891c6105767806bb0be92a54cc1459ae48c68c0d3a6aa17"
  license "MIT"
  head "https:github.combensadehtailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c85395454cf8eba203893c94d863c3467afa45175a383a355cf5413c6548a5e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "361e8ba97a5bab4b4d3e485c381c8621f84339979c5a9d6bfc47160e4153ff15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1864a6e47c4bcb1d84a9e35bc8e7b173f5f437ce1e576897b8bfc61c4fcb0316"
    sha256 cellar: :any_skip_relocation, sonoma:        "db2cb9f51a1c24055ff9f8e5d3bc522d83fc56d0a1b28bd5e534d005b0cb0950"
    sha256 cellar: :any_skip_relocation, ventura:       "d50ea20bede326abd4359fb3a2032a65910b6bf92bb1d313cef9ca112d49ab21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a2d071e4d85dc929916cf0ff537585e7cb40d01c95a3bbda60e2e9053d5b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d97dad3edf90b1984b3f550ba70a3cfe5c0489c4ff18fd12fca9d9f916283b35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionstspin.bash" => "tspin"
    fish_completion.install "completionstspin.fish" => "tspin"
    zsh_completion.install "completionstspin.zsh" => "_tspin"
    man1.install "mantspin.1"
  end

  test do
    (testpath"test.log").write("test")
    shell_output("#{bin}tspin test.log")

    assert_match version.to_s, shell_output("#{bin}tspin --version")
  end
end