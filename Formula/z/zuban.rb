class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.6.1",
    revision: "f319049914263c08da5f27a3bad49a4b7d444b17"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cc388fbee41f833f922caccfeb11dc401b7e328ff48303e90421448d02e5c8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b71586fa9369f3db6573f2121a5f28b6c5364dd3408808275ffe616e000a3ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc50b4ffe203f946ebcdc7887832c7f73a8e74590726d8cde6330c839869e5f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "66543157e2414f39b7c6e3bd8a38be664bb3acbc872e496fc9b3e51714dbaeb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1ae67ddd467132afae9648d4ae89d518a42c3ee9a8d3d163a73ef617ee5ba0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c133a22ae3c1921caeb392a941199a61a3719fb419af5bd7d0d0a385c0d374ca"
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