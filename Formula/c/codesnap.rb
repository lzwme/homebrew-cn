class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https:github.comcodesnap-rscodesnap"
  url "https:github.comcodesnap-rscodesnaparchiverefstagsv0.11.7.tar.gz"
  sha256 "9f51cc348795e8b4575ebb130857638e7dd602a51c8063dde57f7b9c6cb7bfa3"
  license "MIT"
  head "https:github.comcodesnap-rscodesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddb921e7129b42dc9670cd629dce8bf048b3b692a9b7f3de36a65a1112b2c670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0c9b1eef23ce4b536ed8cc896e52aa5be22a244492698977f95eaad12a5c53a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62a33f81d0dfad746e7b949a8039d3add18264c8f1f56810563cb53f2987f730"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f8e1f0720fc1fa3e519c5b83c006d583b9473bbf425d9b66e6605a5ca65c553"
    sha256 cellar: :any_skip_relocation, ventura:       "c985a1696581e2451bd44d6f38982c9167d221d890d8f36aa80d1de6cb715123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea2ac1b53cf8174b57e735744a61c375eb01cbf58c7918d0fab54076d6d740a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d226cab6617bd70a075d5ee54804d6fb3911765a1ae43d32e7fbc94398dd0c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cliexamples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}codesnap -f #{pkgshare}examplescli.sh -o cli.png")
  end
end