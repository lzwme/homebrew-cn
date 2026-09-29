class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.1.0.tar.gz"
  sha256 "e270ecd9e0f4fb1583ef4e2eaac79e657d7dc2891cb40242929c287b427dd700"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64189a92ecd4b39281f8e607fdf83bcd79a038d6a81198cd6a4791bd87cb9769"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64189a92ecd4b39281f8e607fdf83bcd79a038d6a81198cd6a4791bd87cb9769"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64189a92ecd4b39281f8e607fdf83bcd79a038d6a81198cd6a4791bd87cb9769"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f192d753d5d8c4a6ee918a08eb807e2dd4f1ef7d514adc8b76737029ae516ef"
    sha256 cellar: :any,                 x86_64_linux:      "35e620a2df49d187296c053eeba2b78e74e98876747e8cc1a620a29c0c9f1181"
  end

  depends_on "go" => :build

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end