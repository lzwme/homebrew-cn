class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "77737a459a6307526f840dda0da29c631062b9600264f56f9639ae12d102a34a"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d868cf7c012f4a1993a08455ba29aa859c214aab83ebc58e954a8dee6ea3f2b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d868cf7c012f4a1993a08455ba29aa859c214aab83ebc58e954a8dee6ea3f2b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d868cf7c012f4a1993a08455ba29aa859c214aab83ebc58e954a8dee6ea3f2b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "052f9a5fdf083f5edf7ab02016ef1f80ca97277cb6f7bd6af85ab404772771ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "563fef8dd385ce0fbf9b6d52c7c429eaea1c215e091ae885ad0aa2ee715b18c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3177098f8f26a6f73987cf028770dd1f365c992613de98ba7ffd162cd752cbee"
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