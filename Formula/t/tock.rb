class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "9a3747d4cce00ed2755718a38255b5c0f33d5c09b5eac852c35ae437a85ad0d9"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bd2b8c71c993fe5c836dc22d2bdabe8c8e300c36f082c3b3ebe171ec223ef9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d8b5126cd1eb2883c8a041a4c9a6e04f11eb2978b3ba87ec45c9d215f4cfe2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fcb35e1d7cb63885e625f8c6f1c84661fcfbf35a131491e52862f475075821e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6d6e0b9eb29f9b1603e67aecdc4c3de9324f86b0c9ddd149479131eb0fa7ea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d042a75022f1747af79ed628e31ef53b984fe7c84dd57f88ec12b2ae1af3c3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f6cdba88a424b028c7ab76a843211c68983266a1132df464688f9589a297a8"
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