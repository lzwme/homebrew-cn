class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.323.tar.gz"
  sha256 "4e64e92764a2053ebd25c5cbfc476bc34a421d5e0b1feb2596ec9c1f88627df4"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a069d0197157e9648b53d715b1bb1aa3f497ea63168ef3259cd5be3d8502569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a069d0197157e9648b53d715b1bb1aa3f497ea63168ef3259cd5be3d8502569"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a069d0197157e9648b53d715b1bb1aa3f497ea63168ef3259cd5be3d8502569"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b0fa993f370a8095d7818babee21494eafeecb5d32cd67a1db94eddd62caf7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaa5e859cd73781ea5e4aafbbfef4579d0acbe4e6b6861c923a9beb2f0c0ef45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92a85a7724dfe50f28f4f2a70f486797aa85898aecf7140ba1876aba556850a0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end