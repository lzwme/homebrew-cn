class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "93b407eb33a1456e5a6091aa3f0b0e7429aa4c1119e6e7630167b5907898ee99"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78c00ca4f51206cad121301d7626f85ec8a7493bcef8c1cbffbdfcebf43e9142"
    sha256 cellar: :any,                 arm64_sequoia: "fe5b4db337ca21c7532e9328b076fd173cec2c484899b1f956dd3a1f972c5744"
    sha256 cellar: :any,                 arm64_sonoma:  "6a889f25b6f2114348c6d8b2ff4d0dc6449bfbc22ad026e2f34e1206321b0336"
    sha256 cellar: :any,                 sonoma:        "b709f76dacbaa04d63135427236345cdb90ec539ea3787048dabdc2fd5feeaa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164c79b1a370c64703ee5bd89e9d164b105a6a61e521260cc80ca418e2c33153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46112078e2871bfc281efed1fc29fc7bc44dc8ee66e66e5f2038c3766e4815c9"
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
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end