class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://ghproxy.com/https://github.com/goreleaser/nfpm/archive/v2.30.0.tar.gz"
  sha256 "8ddda2490aea4b49a9b2e0658b59eb9cf523931466236ee689525ca8a4c8325e"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db7922f667122ee0d8f05efbea2f30edaf85f8771109f71176666efaad513f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7922f667122ee0d8f05efbea2f30edaf85f8771109f71176666efaad513f5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db7922f667122ee0d8f05efbea2f30edaf85f8771109f71176666efaad513f5f"
    sha256 cellar: :any_skip_relocation, ventura:        "7c1a1725e8b788a6370159d78165e1b4c60a7fd54f69ec30b64bac9cbd2a7274"
    sha256 cellar: :any_skip_relocation, monterey:       "7c1a1725e8b788a6370159d78165e1b4c60a7fd54f69ec30b64bac9cbd2a7274"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c1a1725e8b788a6370159d78165e1b4c60a7fd54f69ec30b64bac9cbd2a7274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0799f559a8d2ba4f368cf9c69220eaeb9c90fd7ed3091588f4c8f942e1b52b26"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example configuration file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end