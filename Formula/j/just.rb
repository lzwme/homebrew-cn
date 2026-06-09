class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.52.0.tar.gz"
  sha256 "cd869b45801f1434d26c05df7ca999b7b56c7d1d57fb1211cdfd2526ec28f130"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc70baa94f05a2633a33227f6354d6f23208666922fd1d5756ba795e252be85c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fee2d57d32235f041a57c491f48b62d965aeeb5474ba91615ed5204004f1355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a6a0397c6eca3eb6436cca765bc485906c403ae367780396507a9cced6d19d"
    sha256 cellar: :any_skip_relocation, sonoma:        "de20d3b4bb04a319b89159948a97066c095331424f6b9f99d627b558059c8fab"
    sha256 cellar: :any,                 arm64_linux:   "6e34ef555f798605d59bf1d6f21a9fc8d6286c7df167674547706c92da360aef"
    sha256 cellar: :any,                 x86_64_linux:  "6bc0b5363ac649e47798b6951a5da034c33ac3184b9667dfc8f136931ca0cf41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end