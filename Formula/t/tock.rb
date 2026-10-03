class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "3da749aa0025f5c7bb85dcedf34fbf604f172da073a97211276c103522c1702e"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "822368ff7805b35ed81c5e9a8bab7d23baa25de7ffa0795e4a62029c57831964"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6672b2ef7b53c4615f46f19c81c252740a8ae0c3ff809d6e12e5bcfb98a2d9c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2e0c23e801e2b0211a2de6cc9c1703961f5a5b2e376583985bcd765ee06bbee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7dda206e228c92ff370f5f0052e56baafdb7a347308731ffa7d7c33b2631d9d"
    sha256 cellar: :any,                 x86_64_linux:      "cc642e97879862db7ba89f9f04f1ee0df6633f6c31af6335f3fbb5af9f3d2a3b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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