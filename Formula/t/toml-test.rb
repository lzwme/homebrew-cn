class TomlTest < Formula
  desc "Language agnostic test suite for TOML parsers"
  homepage "https://github.com/toml-lang/toml-test"
  url "https://ghfast.top/https://github.com/toml-lang/toml-test/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ea14319a926cfd7d418e4b450b47264c478b38ce99280f0cf273c574536e544b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b8c0ce050c61d3e2742e6bb08d83eea25bf90a01bc8d6d8e9b1d8aa8495c9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b8c0ce050c61d3e2742e6bb08d83eea25bf90a01bc8d6d8e9b1d8aa8495c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43b8c0ce050c61d3e2742e6bb08d83eea25bf90a01bc8d6d8e9b1d8aa8495c9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1e3befe97900b6bf368ee22fdda7f5855dda4ae1ea36e5da3806787341f8e7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "059593ce826444b89566cd19de49dc06a30e8193a902d8bfc480b32c07435305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ae3ea138cdabd4d24f6afb16b72ae4f9c0ebd390d8d7b016aa2f06607294cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/toml-test"
    pkgshare.install "tests"
  end

  test do
    system bin/"toml-test", "version"
    system bin/"toml-test", "help"

    (testpath/"stub-decoder").write <<~SH
      #!/bin/sh
      cat #{pkgshare}/tests/valid/example.json
    SH

    chmod 0755, testpath/"stub-decoder"
    system bin/"toml-test", "test", "-decoder", testpath/"stub-decoder", "-run", "valid/example*"
  end
end