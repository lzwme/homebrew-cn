class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.50.3.tar.gz"
  sha256 "f04ec59cc69e262dbe9c6ae825da76f7697538a8a1c5a6316cfd7ebb1b7d5982"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "43633ce8359ea64f35b1baf4d8f1fb75e979c24b260f7202133fef82b2e644b9"
    sha256 cellar: :any,                 arm64_sequoia: "723c2a1f00d8dde57a5a515294dbc9551006576b19b817e2bbd225c2541f8777"
    sha256 cellar: :any,                 arm64_sonoma:  "fcbf68624d0214fd05b120b20464e3ef91afba751df1ec34880d5d88c2533355"
    sha256 cellar: :any,                 sonoma:        "59db1d7a19651d767d28f6e629a9b36e6b5740fc0ed8b7ca4da591ea24a882a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e383a03ed335abf6d3e42bb70878fd8feca885d4a11622dba955462d49a9af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "375749135cc7cb57ec7e9eca04569619bb4353de5ca45eee2d40a11e6cd5daac"
  end

  depends_on "go" => :build
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