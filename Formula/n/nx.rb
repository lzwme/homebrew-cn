class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.6.2.tgz"
  sha256 "abd8b562a4ad65c6843a0b076e2bee3ca7f13aa8a0b3a1aa2683f0af9fd6586d"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f56cfb729dda0e690814e8ecbd626313c73fb9f2938c6eb31acda2b7d0887dcc"
    sha256 cellar: :any,                 arm64_sequoia: "eccacecc9e12ea70be4c07e82b567af31354a32487f305b3b878b4c16ea40a0f"
    sha256 cellar: :any,                 arm64_sonoma:  "eccacecc9e12ea70be4c07e82b567af31354a32487f305b3b878b4c16ea40a0f"
    sha256 cellar: :any,                 sonoma:        "b11a7e5a4462be32ff620a295c4eb809b6afebc20df09167fdecf5a442e4946c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d6de19bc9ae442052d3c47a8ab926aacae91c896485453da30cf78612b5b8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e96af3f20e3220312569482bdbfe91be1f9897accf8e60df9eac637071d9a5e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end