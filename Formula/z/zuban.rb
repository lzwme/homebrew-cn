class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.4.0",
    revision: "b50f11f670ff60eb72d4cd1f1bf708ed9b7d7224"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436889ca850a720c62e823f944544b0fa1f70592aa31967aae13756a181df1ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96cad454bab8db8f6e443c95a05971feb10de70af27af740e8b662c66cec58e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5822d344a8b801ee06bb8fda8cecea5f9b6f5d53cb612f2b50c4ded64dd61121"
    sha256 cellar: :any_skip_relocation, sonoma:        "302dbdc02ea34cc36cb4884ad4ed237c6cb3bec9b5758ee7732214a7f80408f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e05ae9eaebe47e982e766f54657cf737f19fddc760693a8cae54317c29721295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "423da81edbb59e9a192f0e881976aed13f8144a41297146925fb10d5c39666a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban zubanls].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match "Incompatible return value type", out
  end
end