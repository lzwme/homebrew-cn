class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https:github.comwakataraharsh"
  url "https:github.comwakataraharsharchiverefstagsv0.10.15.tar.gz"
  sha256 "000c35dfa033d8e70b1e5c46b471397581f48a6d698ba1a8be6c6be6f824b322"
  license "MIT"
  head "https:github.comwakataraharsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e177987c659c5778c76ebc560b3c0be8c7c1b599b6ab0c4375ca469b31d4ef63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e177987c659c5778c76ebc560b3c0be8c7c1b599b6ab0c4375ca469b31d4ef63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e177987c659c5778c76ebc560b3c0be8c7c1b599b6ab0c4375ca469b31d4ef63"
    sha256 cellar: :any_skip_relocation, sonoma:        "df08ab27386a55b3da263d2ebb0172e9499ffb0b5abc0347eb46e2ff67e38111"
    sha256 cellar: :any_skip_relocation, ventura:       "df08ab27386a55b3da263d2ebb0172e9499ffb0b5abc0347eb46e2ff67e38111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f886079d7cfe3c054717edaa8bcc48bd92e788a249459a2b02bebc1c58a0438"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Harsh version #{version}", shell_output("#{bin}harsh --version")
    assert_match "Welcome to harsh!", shell_output("#{bin}harsh todo")
  end
end