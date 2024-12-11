class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.9.2.tar.gz"
  sha256 "fef179d27d161638f757912ef3d965f2fb30bc2ca45bc849ca0b4c0d970c9b37"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52afa082cd2e4a63c8e87364003a5b484c73f67b575090d18e9d378d9f2107fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52afa082cd2e4a63c8e87364003a5b484c73f67b575090d18e9d378d9f2107fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52afa082cd2e4a63c8e87364003a5b484c73f67b575090d18e9d378d9f2107fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "86a1e17ca9fb789c9377ec93fe48917ab12a0bb32a546c72e19f03d2067bfe71"
    sha256 cellar: :any_skip_relocation, ventura:       "86a1e17ca9fb789c9377ec93fe48917ab12a0bb32a546c72e19f03d2067bfe71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "756f7d0017e34fb00381d19bea38ad38005f9cd8a5ab34cd1cd19779f436ab50"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkumahqkumapkgversion.version=#{version}
      -X github.comkumahqkumapkgversion.gitTag=#{version}
      -X github.comkumahqkumapkgversion.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), ".appkumactl"

    generate_completions_from_executable(bin"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin"kumactl")
    assert_match version.to_s, shell_output("#{bin}kumactl version 2>&1")

    touch testpath"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}kumactl apply -f config.yml 2>&1", 1)
  end
end