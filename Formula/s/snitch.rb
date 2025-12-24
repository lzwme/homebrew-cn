class Snitch < Formula
  desc "Prettier way to inspect network connections"
  homepage "https://github.com/karol-broda/snitch"
  url "https://ghfast.top/https://github.com/karol-broda/snitch/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "5dce1da7674ffd46ad9aefdd638a52b06fd4f1862fb19d5d087dcd16a429bf76"
  license "MIT"
  head "https://github.com/karol-broda/snitch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98feefadbed40bf2b2808643cf0fd9befb89db271727650c447b8b8580f0ad4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c47e2025387605971bd5541195f80208181e90026412a86f961f7ab95b0c05f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7cbcddd8562da00af308ffefafe80e5601a225f5f8e1fe8f3761459b842733c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9adffabe798d31c90ff6129cf5effd0d575837a6e1a28022fa1e18ca3e95fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbb15c156495d7ac29e582a4fad06782cc2d79e7435ea78f10f4e2ee68c99ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fd024b1aa37d3e34adfc01d70e3c8e92002b6908695083a81ba3d6ed8c6e390"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karol-broda/snitch/cmd.Version=#{version}
      -X github.com/karol-broda/snitch/cmd.Date=#{time.iso8601}
      -X github.com/karol-broda/snitch/cmd.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"snitch", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snitch version")

    assert_match "TOTAL CONNECTIONS", shell_output("#{bin}/snitch stats")
  end
end