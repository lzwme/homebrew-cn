class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://ghfast.top/https://github.com/gastownhall/beads/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "b38552d1a310d93f4b7b23f15bf1d0cefd53e565d7f43ccc90f8956111905cf7"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f8e7608f48d4ad95d4536adb5f7e40c4af264feaa6744dcbe3641692e85bd3f1"
    sha256 cellar: :any, arm64_sequoia: "f767d54d71733ade3031c0596bd5c3b3b15d9b8607f67c240d252975ab473b0b"
    sha256 cellar: :any, arm64_sonoma:  "0459c86c6b4bf4763efb0b661838663a9ba5029eb24af2fb9a57872a2ee40509"
    sha256 cellar: :any, sonoma:        "72d506aa08d2e13999f55dadf90a1224f700b95f1c99b209138707f48a1c674f"
    sha256 cellar: :any, arm64_linux:   "1461d6fbc213ade114fff277e257b93e2ae326f61707d200efe9c26dc5d411b4"
    sha256 cellar: :any, x86_64_linux:  "3fd5b4572ee0ddbc380e370091039255d45e89be6aadaeae7c9f31223b82f9e2"
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

    system bin/"bd", "init", "--prefix", "homebrew-beads", "--non-interactive", "--stealth"
    system bin/"bd", "setup", "claude"
    assert_path_exists testpath/"CLAUDE.md"
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end