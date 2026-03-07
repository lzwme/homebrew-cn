class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "ec45559b01c27b3bc9914ba56b4bd1ff45819794e039e8d5e321a754203775eb"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35e7ad0f9b168d3f6b8aa923c7cd58edef121476d4185859041ad99ab6822a2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35e7ad0f9b168d3f6b8aa923c7cd58edef121476d4185859041ad99ab6822a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e7ad0f9b168d3f6b8aa923c7cd58edef121476d4185859041ad99ab6822a2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "703e2c5d7658f34302a73bcadbce119b5eea25be2468e2c0fe9a1946ada0cc87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec8d7851dcc1a810eb539ffcb5801a4ba4a4ee951fcda0508f57e51a16d636ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c7d86f9bef3b8efce86106286ebe676f2724fdf7a581a9279caa8688470a4c"
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