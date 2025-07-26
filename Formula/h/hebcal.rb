class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://ghfast.top/https://github.com/hebcal/hebcal/archive/refs/tags/v5.9.3.tar.gz"
  sha256 "4aaa9be00d742ad0c5f0283862588f5892ce9f86bf41454f65511985eb95a814"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "774fea1e2e46b82b1afa52bc529ddf57c56ddb435a4f1047be6014a411c6f1ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "774fea1e2e46b82b1afa52bc529ddf57c56ddb435a4f1047be6014a411c6f1ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "774fea1e2e46b82b1afa52bc529ddf57c56ddb435a4f1047be6014a411c6f1ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "158a55651835153bd561cf952248e4348b2b2d0e7cce7548df4436794fd5c4bd"
    sha256 cellar: :any_skip_relocation, ventura:       "158a55651835153bd561cf952248e4348b2b2d0e7cce7548df4436794fd5c4bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9879ed8a93beab64bdeeae3cbd98afa17904107ff46e4b462089260cf96d1ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1df783787de43d5c3a61aa2003b346e4bf7130aa35266fb24007a9be622b3d1b"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end