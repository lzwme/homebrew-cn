class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.49.3.tar.gz"
  sha256 "88e5a72fb7820887d5e5bb0ebf414f1704de385ca2097e3e05149333351ae5f7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f045178407d61405c52beffae13cc1bb236653a48dab84debfe860f26592be76"
    sha256 cellar: :any,                 arm64_sequoia: "0e84123dc74575740119bc0cd1055a940a8d68c933b67b11acc5f99655962dfd"
    sha256 cellar: :any,                 arm64_sonoma:  "2fea67bca938fb5d642059f456145d80df4f296d0b99d7f7aa77dfbe40a6d13e"
    sha256 cellar: :any,                 sonoma:        "43f8537ad797c7409d0d11130df77ddc748bbe2eace349718f480a708a48805f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d45e15a039a64ab9c3048c89969527ca82edc63d1e4a50ae30ce39fe2b8d106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8c90cc2c57259ec21191a05aa50b2788e6403275993c675a1ced5c2170fbfd"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

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

    shell_output("#{bin}/bd init < /dev/null")
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Connected: yes", output
  end
end