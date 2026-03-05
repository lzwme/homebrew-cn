class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "753fabab40229bff44a7761ea91dd6988ac79600429594f47d116a710c242f6d"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92905410e5a518360c74a183511517cee1928e5c26cdde7002ef8f1d658f36be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92905410e5a518360c74a183511517cee1928e5c26cdde7002ef8f1d658f36be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92905410e5a518360c74a183511517cee1928e5c26cdde7002ef8f1d658f36be"
    sha256 cellar: :any_skip_relocation, sonoma:        "1231860ea8700bf8f74f2186a391680a79f3116a709a0e359c89ea647ae74b86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164d8b6e94570695fea70438b7c61fdc332005426e5e5e7e7331d9f676063100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dee1d021ef48c49076aef4e36b54ab7bd76ea5358bc349b900ac0abba0d58ee"
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