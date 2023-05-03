class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  # git is needed for dune subst
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.32.1",
      revision: "bcbf83c52c76018ce4a6cd86233de1601ddf9422"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "317335ba0e6ffcf64ad0d5f97c19a7496100319c271c4135e0ed70155f464cdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282fb3a0d478ed5107da6a6e2da7f7c32edef3d7db8ccead451ae9dbf3473169"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6304b8bc94965f0b95368bba6f5e12fcb980e6147b350441cbfae452d707ccc"
    sha256 cellar: :any_skip_relocation, ventura:        "035f6b1a32905e42f65d5298d215b95c0b21ed99e73719b85b79114f9f3794d4"
    sha256 cellar: :any_skip_relocation, monterey:       "ecb25ea82feeee8289eb2ab8277be75ab683e0ed6ddc528e2823dcb035f17003"
    sha256 cellar: :any_skip_relocation, big_sur:        "131034ae09b578292a0e6555337bf3cd0305f03b4781dba81fcfb252f36d6399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88077f0365b8676f3808071428bb07609f203d490e2a1d3df6a6bd5b74ae1e84"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  def install
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "bash", "-x", "scripts/install_build_deps.sh"
      system "opam", "exec", "dune", "subst"
      system "opam", "exec", "dune", "build", "@install"

      bin.install "_build/default/src/stanc/stanc.exe" => "stanc"
      pkgshare.install "test"
    end
  end

  test do
    assert_match "stanc3 v#{version}", shell_output("#{bin}/stanc --version")

    cp pkgshare/"test/integration/good/algebra_solver_good.stan", testpath
    system bin/"stanc", "algebra_solver_good.stan"
    assert_predicate testpath/"algebra_solver_good.hpp", :exist?
  end
end