class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://ghfast.top/https://github.com/goreleaser/nfpm/archive/refs/tags/v2.45.1.tar.gz"
  sha256 "ff829107b1c96014fb910ea6d2260623ac98f16603d894e037fbd10e2fef6aea"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d817431c2b75b908320f45b02e044f2f386b04053d243ea55ea9cf304558d8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d817431c2b75b908320f45b02e044f2f386b04053d243ea55ea9cf304558d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d817431c2b75b908320f45b02e044f2f386b04053d243ea55ea9cf304558d8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaa3ac765e84596de7c8f34372a39fc2718e3e76b29fbc3cf9283e55fdb5318e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f98f17e1fba29e41ccf1c2c947e8c9945871aebca12dbe7b4c6398c39c521560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8320974e4c68099c9529a57a07d30eec33ecb7043c6f8cd68db1c0c7b942eee2"
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