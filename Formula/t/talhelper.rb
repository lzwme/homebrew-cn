class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.43.tar.gz"
  sha256 "a2cdc4062a61e35d270f265ed77cb97f9f17f82cd9423ed6c71f8fa8bcc250cc"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12b1656f1a11b5809c050d12af65c68a8139c6465fd804bef3171e53d91a44e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b1656f1a11b5809c050d12af65c68a8139c6465fd804bef3171e53d91a44e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12b1656f1a11b5809c050d12af65c68a8139c6465fd804bef3171e53d91a44e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ca2e53914a34ca668d4c82f52fa7f92b80f1b9f58d0b9315ddd8c96329419d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3be44cabd989d5b54c57209ea082e793d4cef3595b5180ea38faa50e32b039bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb0a4e5ae49d265c69e3f526bee99fd7b0f57bc3d0b112891ad737b07a326a93"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end