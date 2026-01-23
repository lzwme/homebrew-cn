class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "d47826717cb369cf0874e6ec61c46c11c95fb8f1afa697994a25c0b5caef8232"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31ed192011c19b37f7874e7482c03959e5a43aff9e3a23d74949cb5ac2b4052f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d32d14c5cca33aa080ecfb16144993c897d14ec1a2a217bb107e9df143ed864"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "426cc34c229c4c6808ab2d475a28d5d415b2c2af89aa0225ad3e5fa1796d0bb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fe84617e87fc4db0672954d441166f0670c64bf90eba4b7a957bcd194c0578a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6803c786a1600f094ff0978529ef0ccc63ce750b77df19675fea541e937c69bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd0816a81f24ce1f614dd979df0c0a053790e5c278b7463c519da999986a59a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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

    system bin/"bd", "init"
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Connected: yes", output
  end
end