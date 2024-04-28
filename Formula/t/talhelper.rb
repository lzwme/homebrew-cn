class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.4.1.tar.gz"
  sha256 "4ed54280f0447fc543a6147e8fb1eb4e7a1c2b70367aed5c7e757ede9329a338"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "846ca448fff0e56c32343eb4c5ac4ded13012f76c8c862b3c65dad5070ecac65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71a9fa86bcfa5a44e217efa8dc300841e652ae7402756d7f2f793c2ca50ada07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d06f38be62a89a7e22d0a0b3cf6e7b74dd338cc9ac59957bfe9f4f2ed3895e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ea0984c8c4b67faa947291885b7a54002a8f0c1d060e25fc608cab52385b211"
    sha256 cellar: :any_skip_relocation, ventura:        "03f36b462e6f8733e06397acd4f9abbe1a4b2ceaa68b0e46fff8ef5746c28c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "8a38b17475207b83800a9fcf3107c3abcfc91398f648fefdb9ec45b4e31ab06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e0ec6e63f22b821363cd33dc4368f77e815387a53e50d22230ad3dd19e33ecf"
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