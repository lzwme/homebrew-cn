class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/2.2.33.tar.gz"
  sha256 "5bf46a6519b19a0fc28c7c667fc0c186869eb38a590327522ee084672693fc25"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b623b55056ca09ae45b62bec6c481c72156bb84cab898171d72d6478d43e3b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b623b55056ca09ae45b62bec6c481c72156bb84cab898171d72d6478d43e3b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b623b55056ca09ae45b62bec6c481c72156bb84cab898171d72d6478d43e3b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ea3203731537ac3887b7d9c5c371b80350b7d252e794ee98192e8c92abf825e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b623b55056ca09ae45b62bec6c481c72156bb84cab898171d72d6478d43e3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b623b55056ca09ae45b62bec6c481c72156bb84cab898171d72d6478d43e3b5"
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