class Snitch < Formula
  desc "Prettier way to inspect network connections"
  homepage "https://github.com/karol-broda/snitch"
  url "https://ghfast.top/https://github.com/karol-broda/snitch/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "0dca3cad9563e2bc76c0f23dc475d1707644971d51f52ed0a4cd317f30d05cb8"
  license "MIT"
  head "https://github.com/karol-broda/snitch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3003663bfb991ef0bb9693c2a54142e50e3c67044d66cdfc803280d680396d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea8e335bd6d1a4144d48a9bad65e553a22912154a5950dd91325c0f806a20dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b4708821544b9d95af38acc4f597d42dd380157e4196f5ce546ba35fe9054ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "58fe8e768035189d46fa13c4292045b958514c5d41bfe6cca52f17b978f074dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78f8433e1b7c53cef5cffe1539b8c54a971ae31d635e604896525bfe3d4b3d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3414aedecc982a10b31fb485945dbe301b7216477d73b5b0de62f755f78a0a4a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karol-broda/snitch/cmd.Version=#{version}
      -X github.com/karol-broda/snitch/cmd.Date=#{time.iso8601}
      -X github.com/karol-broda/snitch/cmd.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"snitch", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snitch version")

    assert_match "TOTAL CONNECTIONS", shell_output("#{bin}/snitch stats")
  end
end