class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "61e135305e7e6a4657435ddd0f25017d98ada281eb864a841caf0ea1e82b4034"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcc1b73b7e77e017905ca1d5d137803bd92b8a5b2aa6fbdbd526d256d8044616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcc1b73b7e77e017905ca1d5d137803bd92b8a5b2aa6fbdbd526d256d8044616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcc1b73b7e77e017905ca1d5d137803bd92b8a5b2aa6fbdbd526d256d8044616"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d89e0b20cd560c0d3f4ab2fd0cb46c3ef77c320b1403b3dbd814de316761e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "946dc18d42b0e008f8b85ce3fda07b81c253d1734a7351e5a31fda21f03694eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "195c8dfad0afe028ab757152ced917235f5074003792ff862be10ed800f24ab3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end