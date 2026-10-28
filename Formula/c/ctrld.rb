class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://ghfast.top/https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.9.tar.gz"
  sha256 "7f41dd435a8d36214be8da1fafb46edd0cecf4a16cdf26b5a070fdefa2c40cf5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d8281bde63ff935f0909ffaf0b577ad6fc1a01ddca05e301fe5602304e03a5c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d8281bde63ff935f0909ffaf0b577ad6fc1a01ddca05e301fe5602304e03a5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d8281bde63ff935f0909ffaf0b577ad6fc1a01ddca05e301fe5602304e03a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96ea8eb2803467b3d5019ab2ded332524d7d84eb91ae1686bccd71ab4bbd8cf3"
    sha256 cellar: :any,                 x86_64_linux:      "7f9e9ed65366d3928cfc4cd65dd8eb35903642e942cc9b0938b1a4bc75f2638e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/Control-D-Inc/ctrld/cmd/cli.version=#{version}
      -X github.com/Control-D-Inc/ctrld/cmd/cli.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctrld"
    generate_completions_from_executable(bin/"ctrld", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctrld --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"ctrld", "start", [:out, :err] => output_log.to_s
    sleep 3
    assert_match "Please relaunch process with admin/root privilege.", output_log.read
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end