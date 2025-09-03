class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.34.tar.gz"
  sha256 "6f561a2876be44786d8516dc9af1d11d18e8f03b3ee433b470aced7b32969b91"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b29f908ea4802049829ce234f2b17df8b4da153e6744aa4102bd7fa205bb642"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b29f908ea4802049829ce234f2b17df8b4da153e6744aa4102bd7fa205bb642"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b29f908ea4802049829ce234f2b17df8b4da153e6744aa4102bd7fa205bb642"
    sha256 cellar: :any_skip_relocation, sonoma:        "af7edb6fbec2c283362b689fbc9c84792e4247a47622fe2a0bc03d2390408479"
    sha256 cellar: :any_skip_relocation, ventura:       "af7edb6fbec2c283362b689fbc9c84792e4247a47622fe2a0bc03d2390408479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f32d3e9f2fabdbb03f8178a52801642f914ad76458c4b080a783b4eb39799e60"
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