class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghproxy.com/https://github.com/go-nv/goenv/archive/refs/tags/2.1.10.tar.gz"
  sha256 "3384affbd0680c0fa1a31b9bd8738c1acf3a7886bc90c135a540d3aea917575e"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b055aa3963664fca7ec055c5f5787d901f6671a4f8dbdb0d680842bb3899a5e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b055aa3963664fca7ec055c5f5787d901f6671a4f8dbdb0d680842bb3899a5e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b055aa3963664fca7ec055c5f5787d901f6671a4f8dbdb0d680842bb3899a5e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2e34d5ef14763389851c233b3f79446ab4bbc952cf81f06087686a3a0f7a8af"
    sha256 cellar: :any_skip_relocation, ventura:        "d2e34d5ef14763389851c233b3f79446ab4bbc952cf81f06087686a3a0f7a8af"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e34d5ef14763389851c233b3f79446ab4bbc952cf81f06087686a3a0f7a8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b055aa3963664fca7ec055c5f5787d901f6671a4f8dbdb0d680842bb3899a5e8"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end