class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.18.tar.gz"
  sha256 "5943262b891935c2f6cd1f70da22e44d1a7b0968d026ad84a5c0f4df6eb3cb9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b66cd5dde771c9e9d70ab8d6627c53d945d001739943d12334c06435d369a7ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0016e4f79d54170a24b6f53a9f4b0ef3f77fe6af626d132c0374f5b9a63093cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3318e9a848dce910e0c5fa293ddd9e78124a3a91445ff7412614e90c3b3e4b6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1d58c7f1f7cdc484a2de393a74e207593fffdf7102259c4225b86664fa7426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c3a3bd623e3419da5dab9739553b629f7566b1293ad63fb70d7587ce6c07237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1383175c5b64d6217d92b7799686e90526225407b9e8d882e948b9b82c17b537"
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