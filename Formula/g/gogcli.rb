class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "ceeb362531d3277c5b83ce2e4f3d0bcdcb5038c0a6513ef0504698540a873db9"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f797e02bfae52e996e123485231db95d2a99f1732976b10baf28fd870bec70a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b73dfc8dc651a1ff51fe44c51675957397484856d439708564e01d6d1ce2f85e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d911ff3fffa47bdfe07a11c9cc271a0b3ec969326e4726e6e2ad847b61f806"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d67e191cd23b62a35990422d34c7b4d18feccf95ab386de5e455c49b9cf85b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2233563e8a6260605022f14619c734cf1e295644dceb864425ca13aba85a0337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e84459bf9e413b0eed00dc3cb6a11831e23d2dac7a00030516a8ae95ef07d088"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end