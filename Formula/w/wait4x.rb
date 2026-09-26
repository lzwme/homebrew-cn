class Wait4x < Formula
  desc "Wait for a port or a service to enter the requested state"
  homepage "https://wait4x.dev"
  url "https://ghfast.top/https://github.com/wait4x/wait4x/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "841781dba59ce4504deba7c5fc1aa8d85e2b10a1dbcc0749b0ac019a4666a87c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9296d32435327417aea8e0deeabb14118b8bc352754630a3a61c4e3d18aea107"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ed04dd9b78a1e387ca41a2d4ef28ceab382019cb5638cba42d65d3ff17c2c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe4d9c2c90262e35f164f536ee5be2294d901dde4a23e3994ca7976c7953a67d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce02e09281551c0d84df4e77f34415eb5a3694a2940d30f86f88487b21df199f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "499cffca070e55d3cba9e3e35a716aeaaaa7dc97f39f943a89c10dfa62408d7d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "build"
    bin.install "dist/wait4x"
    generate_completions_from_executable(bin/"wait4x", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wait4x", "exec", "true"
  end
end