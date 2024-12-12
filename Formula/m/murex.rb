class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https:murex.rocks"
  url "https:github.comlmorgmurexarchiverefstagsv6.4.1005.tar.gz"
  sha256 "e76d10f433b1b0acfa0a61aae9b24d3b8d57342f616b9e36f2d640e4de4c27e4"
  license "GPL-2.0-only"
  head "https:github.comlmorgmurex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e550225ecb5e48e1d6cb7d579395b9a620fbe25fd82585addb524cf803f4483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e550225ecb5e48e1d6cb7d579395b9a620fbe25fd82585addb524cf803f4483"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e550225ecb5e48e1d6cb7d579395b9a620fbe25fd82585addb524cf803f4483"
    sha256 cellar: :any_skip_relocation, sonoma:        "3924ed117bdfba5adbd1a464e0d28a2870a62744b04cb15bb1ea2848b57ae657"
    sha256 cellar: :any_skip_relocation, ventura:       "3924ed117bdfba5adbd1a464e0d28a2870a62744b04cb15bb1ea2848b57ae657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75430ef0cd35e9021051f31ec9c9e5e07e1669e9817fd80ffeab3257536ae615"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}murex -version")
  end
end