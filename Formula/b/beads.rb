class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "42709e090caf0470753a35b9a5f0723502de9747343f3ccddd62baca1be9ba78"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0893246ebe31363877d721fa2500ce65ecd64bed67e21ba841deeedd45ed48db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0893246ebe31363877d721fa2500ce65ecd64bed67e21ba841deeedd45ed48db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0893246ebe31363877d721fa2500ce65ecd64bed67e21ba841deeedd45ed48db"
    sha256 cellar: :any_skip_relocation, sonoma:        "1985d3c5368a8861d98132e8a63f0f96d5d868390a7f605836c2c4d6176acddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09cd1230a257f0071d0d409be6ed757ad1ae717acf93d1d79719665da218f94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce630b0b14f2dfce443e027bcdd1395141d4f57cc9c2ffd89143732de23cb44c"
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