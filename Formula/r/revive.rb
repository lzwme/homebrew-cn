class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https:revive.run"
  url "https:github.commgechevrevive.git",
      tag:      "v1.3.5",
      revision: "f8e122f43d8156f86ad8da0d27f15d50775f834f"
  license "MIT"
  head "https:github.commgechevrevive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e99091a4435dc26744565ac50f9eb40b1a2cdae73e8b76cc44e4577d47875ea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30ff7e050a509317599f589fe7eb4efda8dc476788859faef73c80f3c2d149f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0d829364e38f4f5e23cc02edb7bdbdbba645bd1bb6d65b5cb84da84d104a5d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "15dc1c7051938c77007c1eaa3a128a495c145b540357d3ad3de39f00782ba50a"
    sha256 cellar: :any_skip_relocation, ventura:        "db3c8bffe03dae2170b63a0f2ef7e938f5438ce2a2b22956f07b669476d458a6"
    sha256 cellar: :any_skip_relocation, monterey:       "28d59530448e386127a1b08b0441ba41a90a731f4001391dc1c8a0dd6863ba27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a572a63784d2deb653aaf7eb4a511a0285e5b3a0fec8d643130e796556752e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    ldflags << "-X main.version=#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        my_string := "Hello from Homebrew"
        fmt.Println(my_string)
      }
    EOS
    output = shell_output("#{bin}revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end