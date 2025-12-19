class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "52dbb092c56102fff61bb920d441e8b4f578f504ed087008015a9ae577d03caa"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "404799effeb0750c90e9dad8b30cf3b700cf6f8c0345924811e8105d612b7958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28b44ce15bc8dfc43a91bc7769ba5fd45be245036a7e1e000d30d01f9ef50b3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6eef0bc85d01e350d3aac9458fe2780bd629a6221e0e3b06d4acb3b507358f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bec964e92384a9efd125f19be6ec647663c65c2a3811bc22dd733cb42aa74907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd433e663ec9b8dcfa79cbeaa71362ab8dc8f3da8ef59d57eac9dab5ebb27f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b4e3bcfa3a797fab4161ff58ee1b97ddc0e48aaa45663048450e8297b5302cd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end