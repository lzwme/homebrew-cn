class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.0.tar.gz"
  sha256 "2e69bf9263de9003d934a40887d45c4ceeef1a7339f0ee61e329dd5fdfae7ab6"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05c4e6f34fa2d6ac922f4500bd200e6a86dc6e524ba56eeb0282def15d199991"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05c4e6f34fa2d6ac922f4500bd200e6a86dc6e524ba56eeb0282def15d199991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c4e6f34fa2d6ac922f4500bd200e6a86dc6e524ba56eeb0282def15d199991"
    sha256 cellar: :any_skip_relocation, sonoma:        "41784c0c000f1c15b68538ce17c9f26e64b4a3d45136110438050da2fb51198d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ee55bd1ef10a6e52ac5b4497335df3d6d58f4ee3adce6a3090b5c563d2f22f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ae6a40f1520b3572bdbf238bc11fcb06d5063c7789ceee344355dfc6afadc9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end