class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "a7fc752afb68a909fa8d42bfa527fc44455000a089eb7448dcf264c3950ab797"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73812021c09e2168656f2ac81c58b1480d6d99181347e1c810c6b81fd8c2e913"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1fac34fd450f47f046e9dbb07aced2dc6e88dbaa0a49acc33e4f1a24103fa88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da169581cf19e52676acf38688b8b107e8f0398887367905b50eba459e676097"
    sha256 cellar: :any_skip_relocation, sonoma:        "de71fee0beb2a100c7d47b1ef69d2fdbb50f867603ed3f09b1d2113cfd00d94e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc5f2f6c3ca830d2a1f866783beb3f6e953b97b5009a852b300ac42e217f43f0"
    sha256 cellar: :any,                 x86_64_linux:  "13e3248d8e55e57ed4a2dacafe3e7f735b82cdcd480df33cc6c6fc72c9a1f519"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end