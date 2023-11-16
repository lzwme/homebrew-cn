class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.37.1.tar.gz"
  sha256 "3d1e335aadb371ce6f5879cc842703342b7571112fa12a8036c6642e5b2561fa"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "712374529d1ec20b30a7d189a9596a1952fc2e60f8c108bcaa9496c77045dd3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b76401cca2c3375c918c1ac150339bb6996377ab740c969b83338d225eef6d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0b70b3b868af876498762177cb1fc916987b2fef8cda3f668f1045da25d712c"
    sha256 cellar: :any_skip_relocation, sonoma:         "902fd4cc40b96bc569519043d9522176edc8855b8fff6282f81a9eeec09f69c7"
    sha256 cellar: :any_skip_relocation, ventura:        "d4171a70f7c1d670a5195a73f302fc7b6426b9c7237d72dc9cf18a4306cbbd89"
    sha256 cellar: :any_skip_relocation, monterey:       "9769b5e927c6d7fc7aef00b0cc29fbfbeffaa87c7b128154bc657c806bfa43f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62cfcf7f8b61fbe5a13e5baff311a0cacbbeec60fd0bcf11a3a51c0af98d231c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end