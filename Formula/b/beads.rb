class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "2dc449138843cd711a72dfe981a6e9020121ef55a965cfab8518a655f2771682"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "75a4be6209971eb0fac844240ae0840cae04fc1bf1365ee79dc2cb209324bdb5"
    sha256 cellar: :any,                 arm64_sequoia: "a257d8b56e3f40f0701d1c52b0cd6d924201c5244e776a04d914034bce2efb02"
    sha256 cellar: :any,                 arm64_sonoma:  "4a6f9e5ba369db505537c78683562eeba55a3d7eeb1e737c123108fc4e64e921"
    sha256 cellar: :any,                 sonoma:        "fd0db48525fb92ddddaadfb0ed18c6f5650696db226f8d9ba1f5eb4506a90778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab09aad65241c6af154c3433dc7905b5f93a9f49b2d361fce9de2d43e78b173b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f85112ff66af6415a7da205b963a924e039f402016f75ef2e7c297ecde9a74"
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