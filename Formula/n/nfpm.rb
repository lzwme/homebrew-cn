class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://ghproxy.com/https://github.com/goreleaser/nfpm/archive/v2.33.0.tar.gz"
  sha256 "0610c317d4945764d46a64fdcb13666248cf92d5e2036b56aea06127546d9cf5"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b6e00d24149071cead895427d49c7ac0effc6955d0c56b19777478b09b7b446"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b43186b7ef22b97e95ebd5d6836b438d20f09142f2cbee0d20c1e872bf626c77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbef3ebcfabe30c1741fdf79894fe3849ec50dc207c4cbca0713a204cc81bce7"
    sha256 cellar: :any_skip_relocation, ventura:        "0c6c3b9e9a0a72d56e4a738cfe3832caed3b0356b2be39a5e12b0a7cef31a63c"
    sha256 cellar: :any_skip_relocation, monterey:       "295d42ac716d9ac6bc96b1744885c79dfd14afae14675968854e9b2cc54f8619"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a679f81f160a19069486a5d41f0acc4242bc24f3b8e0109e322cb8ee1e306ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ca9d48a6715d5c3365c3a8011763c2d6da50854d5c35af0a1a28308828b16f"
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