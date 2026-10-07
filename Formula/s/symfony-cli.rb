class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://ghfast.top/https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.22.0.tar.gz"
  sha256 "00e58f7549b758701ba3fda3d62c00f071c71c086664868c682d5dd70c00878c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fcadbd94f0fd2f5a64a0924313feb8faaea795fbe7d23ec998a4ef819a006e12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1c58c2c0f62224153b9235e6cf0c4e6c58b145c2c982affd0e98edb1bff5bbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d03921135766ceee40f803f63e4546598bc288b4f58f6a608312d76eb9ed702c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b03a2c337ff676ba733cb1a6e04a9255473073bcdb7c79bceea11bedce75c2d"
    sha256 cellar: :any,                 x86_64_linux:      "c66a9a109e002964cf8f268af73c151418d87e481de24fc9462ae155e72dcdb8"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end