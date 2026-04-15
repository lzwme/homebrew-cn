class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://ghfast.top/https://github.com/goreleaser/nfpm/archive/refs/tags/v2.46.1.tar.gz"
  sha256 "cc48ea71807e30c3c3b7d62cd2c64c14af629e800f80cead94926a266b917dcd"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56dafcb2927597036535c113f7b82332af4abe0a57f10338f295138317aa5a58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56dafcb2927597036535c113f7b82332af4abe0a57f10338f295138317aa5a58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56dafcb2927597036535c113f7b82332af4abe0a57f10338f295138317aa5a58"
    sha256 cellar: :any_skip_relocation, sonoma:        "614ea44d8d25bc7a32ab5de87f4a96719c62a4002d95bbc73edd29cc2e9ecc47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f1a7ae455fb83efa4e5c0eb9fd02839ae7ed099f529c3a09f2eff29b6dd3ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e135f65c65a54c516d48cbe103ddd00760b096e7d6fb4ef5d60cbe0d48de738e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "This is an example nfpm configuration file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~YAML
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    YAML

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_path_exists testpath/"foo_1.0.0_amd64.deb"
  end
end