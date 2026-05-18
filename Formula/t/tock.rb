class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "56e67be63ca8ab0d3724853cc3585a4d9e4d898721cce83a51713fda6ab3c726"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3456e65c9ffa93ea826f57ab5e86f91eba83afeef7bca7bd7336a5ccfd47111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c66fe4a383b68fba243d0a0afd1a1360b2f519486ce14aa25db9ae7b0e688ceb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef369d60ef8ea77a5991015074002630bd5eeac4d268d676da120b358d058a74"
    sha256 cellar: :any_skip_relocation, sonoma:        "c36832206cfbe2d2511ef4f2cb5d2d331386cceef4ee3eacda52c418d36f151e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5054d544233f3ac22c6a234f8424494675d5ab197ee7fea97e94613c3856fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd2714fbd1b47355606e9bb815a10468950180ba7c850e6b88ab074121076dd4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/app/commands.version=#{version}
      -X github.com/kriuchkov/tock/internal/app/commands.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/app/commands.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end