class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.12.tar.gz"
  sha256 "9f0c6c6cff2e9293ff346b73ec20c2043c74d0c4c01664b77a94fb783b52ed28"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd0340370403dabd0b046e0b3403fe62a23469faf9e7998b96eb419bd64f7cad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c27d470236be06b23be9e3cb1a41e963fa7f837fd34a194ac51d9a3c2c447c8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b0a39944904896e3e84240ef026dafef9cae566aa4ab58c592e1dc4479b93ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6730fc04d16834f42008b531ae86b6b19b386bc648a04fa199bf19dfd2b5f77"
    sha256 cellar: :any_skip_relocation, ventura:       "d8a772743c3051d147c2576c2c1e3be51b6e1823da5481d26b7d4524ea4a5cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d92058fce4370d1dd31ef84490b4485c9843bd30ecf7da4a471f5ba12594b75"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end