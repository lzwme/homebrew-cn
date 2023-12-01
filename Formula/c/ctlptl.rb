class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://ghproxy.com/https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.25.tar.gz"
  sha256 "1877838eed3f147418098abde50f6276d50c7769877acca09d80a9d8a8d503c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f94c54e89d58582a8cd22340f92889d62e2043b75e3526fb8c91e9f9a633c62c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "625d971e9ff3d7a541283eb6a4c6804413592ba54f1656af23f06e372699cacd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b21a0f7409659f8f7e9dcfca4e2534d20a3fc3b1b8ee40366849ca6d7209681f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f9f2d4d1afc3b89e6265652a37fd756f8ba5552630d52910d33f978cc1f29ff"
    sha256 cellar: :any_skip_relocation, ventura:        "0b0fdfb6b00ab0ad204142614890b63d47a4a9c62c11db280d5257bbf3cede83"
    sha256 cellar: :any_skip_relocation, monterey:       "5b92492175acec6b0cf3fb17d0fcf243517b14d1dd55390037e4c5766bbaf81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "018ace6341a4d18e22433c52afb807166422c48e12ee618527fbd11038bd3b8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end