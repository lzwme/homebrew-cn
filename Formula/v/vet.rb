class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.16.tar.gz"
  sha256 "8e39b4d39957f40b47c233bfa1558591779888427dad37c7a9391f08707672b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41abd1bd42438d29a1041f274e6a2e9be20f1e5a82d56a08752bf344b88d95eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7237eabd378568e0905d0693fe6dbcefb33ea403fbc7efd64f5f1a466d3c217d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5c055ca23834eab8eec12b1eeb637017cf8e4008c3efd51747bdb08f0b67f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc9a6113cacb9280a8b50030c0b4596d18b48138ca53a05b1f6558f35c709911"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9629bf2dacef0c95ac47f354699e4ba265925d84c4d7d1bcada49ea6868d09bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72db7c1c9d5e0f2bcd0f928df33722874b2460dcdd8359843491bb3497806f71"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end