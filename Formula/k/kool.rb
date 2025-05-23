class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https:kool.dev"
  url "https:github.comkool-devkoolarchiverefstags3.5.0.tar.gz"
  sha256 "dde59df46f342028a7dd5ad7454363f4fbf2c0340c48888cc0228d3363a52d71"
  license "MIT"
  head "https:github.comkool-devkool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d92eb2eeb2599551c08fdc3799a9ae7833e8b4d048fbdf71ad80755e52e533a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d92eb2eeb2599551c08fdc3799a9ae7833e8b4d048fbdf71ad80755e52e533a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d92eb2eeb2599551c08fdc3799a9ae7833e8b4d048fbdf71ad80755e52e533a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebfc92b326057aaf8dd012f42ef527b1870e836313608533ac798680094c06ad"
    sha256 cellar: :any_skip_relocation, ventura:       "ebfc92b326057aaf8dd012f42ef527b1870e836313608533ac798680094c06ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5917b2481df14d238eb0bdb4c2a0084d737059e613c60c20497c9ec406c761e0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X kool-devkoolcommands.version=#{version}")

    generate_completions_from_executable(bin"kool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}kool status 2>&1", 1)
  end
end