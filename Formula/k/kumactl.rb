class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.9.1.tar.gz"
  sha256 "16af959cb80b4a81492322db2a8aab0e779de0567cb83b480c89fe9a6e07cb9e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa81171a7eabe5efe3a5eca2573104c59ca95630be5bfa7a29e8f2ce0a2ad01a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa81171a7eabe5efe3a5eca2573104c59ca95630be5bfa7a29e8f2ce0a2ad01a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa81171a7eabe5efe3a5eca2573104c59ca95630be5bfa7a29e8f2ce0a2ad01a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6f7581d14a381060dc52df2f5ad1fe1d8fa8fa2bf10fcf2b00ebc947e954759"
    sha256 cellar: :any_skip_relocation, ventura:       "f6f7581d14a381060dc52df2f5ad1fe1d8fa8fa2bf10fcf2b00ebc947e954759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dae3a5dfe504561a21fda63776621ab6b2f9e910c3449a0cd80109afe9426164"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkumahqkumapkgversion.version=#{version}
      -X github.comkumahqkumapkgversion.gitTag=#{version}
      -X github.comkumahqkumapkgversion.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), ".appkumactl"

    generate_completions_from_executable(bin"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin"kumactl")
    assert_match version.to_s, shell_output("#{bin}kumactl version 2>&1")

    touch testpath"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}kumactl apply -f config.yml 2>&1", 1)
  end
end