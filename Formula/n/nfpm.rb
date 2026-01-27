class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://ghfast.top/https://github.com/goreleaser/nfpm/archive/refs/tags/v2.44.2.tar.gz"
  sha256 "20664e2fa35c81e5826511b9ef1dc16d1b748334a96b1805fad8b7c7833017e1"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceb7635e82a2ada217d9a273d073a339c075fdbae3020a40e2aa3b0ccd3d8a33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceb7635e82a2ada217d9a273d073a339c075fdbae3020a40e2aa3b0ccd3d8a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceb7635e82a2ada217d9a273d073a339c075fdbae3020a40e2aa3b0ccd3d8a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "260070426fe65515bbe2c3aa77ba91c79437fa9fe8180f60ecc100c80e82344b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9af6bdfda8d67e1eaa6d3a2392ded72f8b726ff421c74e9c77ccc9f9b2ef696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4172e5c546d818f6dae3ce962a358b2a602c8eb6c752a5d7423823ab9ead1326"
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