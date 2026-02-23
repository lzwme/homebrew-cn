class Kaf < Formula
  desc "Modern CLI for Apache Kafka"
  homepage "https://github.com/birdayz/kaf"
  url "https://ghfast.top/https://github.com/birdayz/kaf/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "df0ad80c7be9ba53a074cb84033bd477780c151d7cbf57b6d2c2d9b8c62b7847"
  license "Apache-2.0"
  head "https://github.com/birdayz/kaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b54defd615f80e00e937ec26b2794bba3dcc81e04fe4be1c70b2c1e79fe0dca2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b54defd615f80e00e937ec26b2794bba3dcc81e04fe4be1c70b2c1e79fe0dca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b54defd615f80e00e937ec26b2794bba3dcc81e04fe4be1c70b2c1e79fe0dca2"
    sha256 cellar: :any_skip_relocation, sonoma:        "379b9487564e3ea80dd8d2c78dce8b4b195078cc1dd1706e023d1da8e5712196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1945920632597ef44df9b33ccb7f25b6ad66d96f24cc3da14e42129f5709398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aba91729665c1f0f532c253b87e0a14cba5c60d1ca384ec99c80a6603323a4d5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=Homebrew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kaf"

    generate_completions_from_executable(bin/"kaf", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kaf --version")

    system bin/"kaf", "config", "add-cluster", "local", "-b", "localhost:9092"
    system bin/"kaf", "config", "use-cluster", "local"
    assert_equal "local\n", shell_output("#{bin}/kaf config current-context")
  end
end