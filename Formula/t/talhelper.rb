class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.4.5.tar.gz"
  sha256 "7560e23244feb64ded41795d1d197bc54c7cba64325947e3bce5cf865524b0cd"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46ae1bc9b96fe7235333631049964238c50370d26ed87c9b56594441e4a4b017"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a70f1bf7db656f7c4f7f90d434a0c93922f759f42488bfd9cc08eabac83a0db8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2e0962405098cb8f7c04fc93ea69da99339596661363e90172b3bdcf7d4f116"
    sha256 cellar: :any_skip_relocation, sonoma:         "7137544a9c783dafebaa7fdfbc6418c7304ddebabe0241937ccbdd06e22f31ba"
    sha256 cellar: :any_skip_relocation, ventura:        "e08cc7a1810c216c7fa4ba6e9044eaeb80cb8a921af5f9a62f58b54c66f74939"
    sha256 cellar: :any_skip_relocation, monterey:       "367fb3cbb0e8d112f5bbc364410ee12d72788e737bc1c3cf158cdfacb3161fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e44e1b0d975e24fbdb02686c3b96edb4d38151c1d46ad6dd2e98bdf7b02d0449"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end