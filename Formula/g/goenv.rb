class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/2.2.36.tar.gz"
  sha256 "b5caefe2acb742b7bf0fa0758a266565f5c3a7cd5fb27228004c2758cabfcea6"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f2e0bcef0f8c868e705bc8fda3f9bb33dcd37b2cfd13266b0bd471d079cd4bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f2e0bcef0f8c868e705bc8fda3f9bb33dcd37b2cfd13266b0bd471d079cd4bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f2e0bcef0f8c868e705bc8fda3f9bb33dcd37b2cfd13266b0bd471d079cd4bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d8ef476a49c5328a77190dd5d8f183273fcef1c2a2463323c6507929114276e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f2e0bcef0f8c868e705bc8fda3f9bb33dcd37b2cfd13266b0bd471d079cd4bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f2e0bcef0f8c868e705bc8fda3f9bb33dcd37b2cfd13266b0bd471d079cd4bf"
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