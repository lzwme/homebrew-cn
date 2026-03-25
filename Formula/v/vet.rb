class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "b5754b8106d2c3011645495202944f3b1a10df3e590556b6d0875e4cb6a5ac7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ad89144d53da3cc74eb2b98b077b0ab6be0b0bc94c315c869c6f7011280d9c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df2dfd1e07316c011333bc484d498a0012452d90804b95cb93be08ac1b396c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b86d10eae82064b64960ca3c35d5c4b9f1bdfab24ebf057ab04b53c581a4189d"
    sha256 cellar: :any_skip_relocation, sonoma:        "93c7f35ad08a179d7c002c363de646fc753210b36b9c3f81da709d36e81f130b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "619e24119b90116d1d21fc3e53be93823d6a5c7f435d2215ab040ffd6e5ae467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9905e5c64f4ed752de983d736adcde93636e3686cc6e8773ad361d39d9a530e9"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end