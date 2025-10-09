class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/2.2.30.tar.gz"
  sha256 "5c036f3ba0bba96f479d078170b52f8c9e9eea516531b5e3a146f52c37ba4c1b"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c8b2a745f3a7fa25bd3a41fe6b00e472fb4bbe1c43a8ba3abbbfbfecd769c44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8b2a745f3a7fa25bd3a41fe6b00e472fb4bbe1c43a8ba3abbbfbfecd769c44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c8b2a745f3a7fa25bd3a41fe6b00e472fb4bbe1c43a8ba3abbbfbfecd769c44"
    sha256 cellar: :any_skip_relocation, sonoma:        "30dee6000d038d2224eb44a71fe1b2807b0bc947425be1cc1bcaeca13a4393bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c8b2a745f3a7fa25bd3a41fe6b00e472fb4bbe1c43a8ba3abbbfbfecd769c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c8b2a745f3a7fa25bd3a41fe6b00e472fb4bbe1c43a8ba3abbbfbfecd769c44"
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