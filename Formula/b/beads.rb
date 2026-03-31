class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.63.3.tar.gz"
  sha256 "5a9a2330d21fca03da9c6ce1e744a9e8d9a3c889357d21f238b7eb9568828e58"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14a5db5305abb4785679a47900702c5cbfe1e09e23fc215f9521547e4a9e2acb"
    sha256 cellar: :any,                 arm64_sequoia: "19748a68ca260a322322e472c597efb22d09bff7b29af34cdbf1ac95451a46ef"
    sha256 cellar: :any,                 arm64_sonoma:  "fcf39d802265479ff7e10cefe6b419635a75ac16e8f718c3e62802a806f8c842"
    sha256 cellar: :any,                 sonoma:        "76aad6d466341ca483b2767a586966988301cfc2d76782306d29eb9c8902f014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df16eb0e06f00fda549ac819dd4b385946c61e9b3405c129d273c62bf900af76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bbcd58dae111f9f3e1466e4daab6669692b176e9f5eb05651970f7306a193ca"
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