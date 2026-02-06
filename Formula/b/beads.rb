class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.49.4.tar.gz"
  sha256 "f4112b9fb80b6f2d8899c1dd80262f287ef37fd8eb2c7404642026cc12fabbb8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9312befd7349d3d2b8dcda471a74895b32a4b591d1c615d933d0333af9cb0825"
    sha256 cellar: :any,                 arm64_sequoia: "653d5b682fb03243a94779a9abcd3f1e879bf5ba7203c7c5c2ffcf55ad7dd266"
    sha256 cellar: :any,                 arm64_sonoma:  "240c761faf87b7979e78f84ec5a33cc0b7e5fd066cdc9dc7bbe58fa6be9198e6"
    sha256 cellar: :any,                 sonoma:        "66f14efb2670ec42e94d7a202f1a706bb8f3f9f57542febea734d1cf27cff1ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dd174d6fa2454533fb9eb39f52027e49b01fa8730812376c53cae2e2232ad41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18cdaed5ff40ddbf7e9b3f4b21131ee8f70b1b01bad3d41e5a468f8814403042"
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