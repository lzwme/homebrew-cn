class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "4f2c3ea960fbc2d8f5a4cb97cd0191c1f0afb66bcfad725a998089ff0c30dd21"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0da4e0d97fe4fd471f285c47347ad1304e2f62d2ea808637945fe0367b7ee035"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0da4e0d97fe4fd471f285c47347ad1304e2f62d2ea808637945fe0367b7ee035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0da4e0d97fe4fd471f285c47347ad1304e2f62d2ea808637945fe0367b7ee035"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fbc5a10d2908fbe8845d6c228b0b88f42d85c6cde450a9b285c17e90da3c9f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "913349e23c37cd02f1d7e85c4e548d4f77affec93b54bb83c5a7547b4d338887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9ae4944050bc9ed7c728a45831977bbc2d9bbf541acb5cfc294a0670e647655"
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
      -X main.Commit=#{tap.user}
      -X main.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    shell_output("#{bin}/bd init < /dev/null")
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Beads Database Information", output
    assert_match "Mode: direct", output
  end
end