class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.480.tar.gz"
  sha256 "ca128a5095a3ff0ceef001bab39db83634c50ec0b1e033239bba2414581f4a9c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f599495242d9b70f25501c8e84bffdfdfb34dcea23e4c8f039870b546b27f964"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f599495242d9b70f25501c8e84bffdfdfb34dcea23e4c8f039870b546b27f964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f599495242d9b70f25501c8e84bffdfdfb34dcea23e4c8f039870b546b27f964"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e6065ab11bbf2080674be44986a2f3bdaa6e57bb65fa9b3c9f8723595d985f0b"
    sha256 cellar: :any,                 x86_64_linux:      "13d55d102150014b0b91e36022df3874bd29c3c374b37fef4b800c27a8567bb1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end