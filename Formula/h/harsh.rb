class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https:github.comwakataraharsh"
  url "https:github.comwakataraharsharchiverefstagsv0.10.16.tar.gz"
  sha256 "5f9aa624ce5cd32a1e743f3ace6013f00be31f5b04dfe3ae63d48c5ac764c129"
  license "MIT"
  head "https:github.comwakataraharsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e0e74e9e09b72603e705ad8c97ac037f7d4c8b1203323c6b7d56b8357f814e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3e0e74e9e09b72603e705ad8c97ac037f7d4c8b1203323c6b7d56b8357f814e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3e0e74e9e09b72603e705ad8c97ac037f7d4c8b1203323c6b7d56b8357f814e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9d95644237d7d197b601418126e7720355e48fc719052718bab217d5bc5ecdf"
    sha256 cellar: :any_skip_relocation, ventura:       "e9d95644237d7d197b601418126e7720355e48fc719052718bab217d5bc5ecdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64b1121229bc0df4061e53672ffd6d64a762cbefe1a37995b393902c80dccdf"
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