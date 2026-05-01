class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "335098139ad65ff9aa7752cdba454ec1866d6d02f329ea195e9a2bc7882bdd34"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ac8e7282a8e4a5864fc1110e4d537403d90c0dac427b48fbee4c0fb139c1ede"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d24bcacb65b6c3271bd04478ade8003e1a1bc95fb0275f9a98eb02c70beb6eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06dee135755ebe64f23fa998a4eb9bf12f041e7c471eddb6224da555e224a50b"
    sha256 cellar: :any_skip_relocation, sonoma:        "609cbebbb2a2d32075d96c14d42d121e61365b9ca0498f23b55411e24145c361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "567ad0498e144de1b682fe0440ae2c74c289fb422b714a6eaf683e5dd99419c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe9578b65b3a824605f1bb92f779a113d298450fc8ce0b666869392163f4acc"
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