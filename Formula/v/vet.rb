class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "cafa628de006e4c11d6fa5d884d8aafc2e38f7826feb50d309fc66edece5cefb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1967f1934b044953f7e8b9dbf9c76f98b9c6e834b5f215318a1a3bc3e1ba9534"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e7a3df6e2beb2e0cf4cd5f39807f67a2bce86c29be28e9d4f1b6d49a4701464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aa809c9d900a27399acd879b8dfccefe0996825b5256ccab569db6ee9878c83"
    sha256 cellar: :any_skip_relocation, sonoma:        "fff1713ed4a0a4f1c944a61b1ff274b6c9bad4ac70af0eb6814bdac6fae84afa"
    sha256 cellar: :any,                 arm64_linux:   "2b33aa666462b63f321ea2e339580e3bb0f284b3426dfb29a96dfc25ff695d3c"
    sha256 cellar: :any,                 x86_64_linux:  "98a77eca9816e455efe9c76a0bd61dd0bad22e200c7a15d0b1defc4c83a5da11"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end