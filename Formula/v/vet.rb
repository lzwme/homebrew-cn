class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "4b2596d03acdc38b6519f32ada6f89d9a9ff7aa3c1127270e19d5f30941279a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d6dc3225e8bb19756f91e58e71205ba473c79007847e5daae961cf429046872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b9518c807e9d0beeaf1948048fe92bc6ac9306971ca25ba4a3d4f93e2fb50d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f956f65fa1aae6fe50e591cef540e618c11befbdadbac75dbd2e00c3112d735"
    sha256 cellar: :any_skip_relocation, sonoma:        "eea5a1e2bf2c3d2c8cc0c5dfebb2dcce03aeeb7bedba310f788cabf97a829953"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9953314defd20c0b8117f4eb94b4a0382616cdb410abbb52245623467c663a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f531d546b71566922eb24e8d3550775a693d30b92644476285a3d614153459dc"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end