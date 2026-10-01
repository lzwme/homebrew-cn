class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "4ba2b7118bd7128345cb86b329afc880c0cf886a016a100dffd9d9c790545e89"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "406ec10c76b7086194d896dbf5aca1ae7d4378b70ffb37f12a5b2c8108c42b81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cccf78d9a9999be2f684ec0784a9a8dbaf2069769a73eeafb1959658310729b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7e3b21f9ad2c412c925391da4de413d4c851f7c4689d0ea1be8c200cf81758d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8984a164ca3b6617dcfbc020a51e11086ea6a1c1a521dc64f5c975b511c5c0dc"
    sha256 cellar: :any,                 x86_64_linux:      "0498322ebf1fb805912da674cc6a9b9ae2d9c1fc9294cc37f5f76592393b3601"
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