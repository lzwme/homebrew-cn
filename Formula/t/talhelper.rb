class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:github.combudimanjojotalhelper"
  url "https:github.combudimanjojotalhelperarchiverefstagsv1.17.0.tar.gz"
  sha256 "1fb990871f56797967b04346745b53bac67cc03c55523c3eb8e9aa297501ab7a"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77fcf8369d8be5c97bde5a66c336f342964115ee3948587409aae0f19fed367d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61bf446340a5f066bea1918571d237eeeedd53a78f9e4c928f2e316641621319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "656a093797b1f104d1895412ae025a97992f058a45d2f403c62eb4c685fc0abb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f26da708ee3acd0ad9f768078d6e5ff426f0e8c9b131188a27f7ef175a28436"
    sha256 cellar: :any_skip_relocation, ventura:        "0c07388683b5323855b6a1a0a178b361f13dc8f70ec9e832e93c28db11c3b470"
    sha256 cellar: :any_skip_relocation, monterey:       "cfaebee9caf0679dc3e520a29aee936e763777ce9aa219c8cc015764a6018e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64231542694b31ac64790648e6fa29dc5cec9024d7ac461553b12fafd87b3bb6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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