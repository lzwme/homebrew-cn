class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "dff82df9cf72e4b20283af1cb66795aac176db64beda4437fe43fadb73896036"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ebb190b3634b427ce116f06ce4b93e25735ed80c3e3af76da52b1af01821ebd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ebb190b3634b427ce116f06ce4b93e25735ed80c3e3af76da52b1af01821ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ebb190b3634b427ce116f06ce4b93e25735ed80c3e3af76da52b1af01821ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e3750fc3605775e6786c3990babe9295659ab8a86fae802ab2821e57bf7ce3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a99cc8267b290af3de341933b05db821bb09fa0dc57206bab563641c3dee7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c165eaf00fae3bc2663fc8d284e19ada7cb95d99470be11dad9002e9385e1cc"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@78"

  def install
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Branch=#{build.head? ? "HEAD" : "v#{version}"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    shell_output("#{bin}/bd init -p homebrew-beads < /dev/null")
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Beads Database Information", output
    assert_match "Mode: direct", output
  end
end