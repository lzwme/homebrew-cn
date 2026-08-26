class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.18.3.tar.gz"
  sha256 "bf921006f909f903bdd746ff0f5931656e673c19c017fdd7535ca542c46bd101"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f0bae081c69e302a0e3daf48de6d5b2c6937ad47a1c5be355c92824435bc2b73"
    sha256 cellar: :any, arm64_sequoia: "eeceda7eeca706b73286b90d2b282601a0d980a59c8df1edf7886d694c16a85c"
    sha256 cellar: :any, arm64_sonoma:  "7fa58d3162c540ebed57ba0c510efb79b57a6caef257b9fd53fe60565e3bfc68"
    sha256 cellar: :any, sonoma:        "4c5952e6391bbe48df6e198a094b762d6f4e8b0b1ddf1331bf42725499daa997"
    sha256 cellar: :any, arm64_linux:   "174b5a1474fcc6eb7d588a4f58c5077f88782e91aad628d59645cb3b3fc4a38d"
    sha256 cellar: :any, x86_64_linux:  "08c0f400c258bf0d1992f44c564816a2b030800b75d4a05399434d3f617d18f0"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end