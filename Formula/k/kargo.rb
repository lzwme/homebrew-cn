class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https:kargo.io"
  url "https:github.comakuitykargoarchiverefstagsv1.5.1.tar.gz"
  sha256 "713b08bd8d13fe483ec8dda89f42a4186d71ef977471cf994e43d5e6b80a285f"
  license "Apache-2.0"
  head "https:github.comakuitykargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8ed65d972140c3ca775cab197a74adb3bde593d8ead1953e786c63e97755c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1234416ffac31cd38f505497aceffe3a2c3bf711449960e1280fccbc73f7d3e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a5e157585b2dc55ecaa54d44f1aeae02c74c21d36c830475d82b8689aaa64b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "89800a52d9bf1ee16c89e1ebdc39cef2aaafa2fc15576d1e1140518502387d76"
    sha256 cellar: :any_skip_relocation, ventura:       "811d5306e04efe8e1c3483c2966d11d76a4104129824b3fe5da9c322d5954430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1000af3a1091d23d94a5a3b8f0f491a8c3d8d0761194c7e5e5700bc988906e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e20a30b8511ac545ad3694acfbc316d594b7ed7f4f455c6da3d5ef9b67fcfb5"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.comakuitykargopkgxversion.version=#{version}
      -X github.comakuitykargopkgxversion.buildDate=#{time.iso8601}
      -X github.comakuitykargopkgxversion.gitCommit=#{tap.user}
      -X github.comakuitykargopkgxversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}kargo config view")
  end
end