class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.36.0",
      revision: "0366507dd98f96bf6acd5d2753bd0910f2eb0ecb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a4e28729eb9e4790ba984d02f9752a9e3092c556892673e97d4324c67783cd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ba590eb17a914c2ce3c93c775a2d8dc1c9dc58ddc4cfecc20a92686d96508d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16ccaddc885752a02296d260bbff43e1a618183c5feb29f54dc966d282f58a7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d95e9716a7f9bfbed4a9161030ec37001051de2ddb7b18f4386b599b11692ca6"
    sha256 cellar: :any_skip_relocation, ventura:       "d000fd196bc37829af7985f3cfd15a95cae50676acef2250d54cbe088cd207ba"
    sha256                               arm64_linux:   "0c35526796f504d5ea421e2bd2ea9bbb1e5d5889d150563fab318f5fa6a1ff82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92fe8afc06fb2059c4ffd178c2a67eba0b305a60a566ebb80f4fbbce090504ca"
  end

  depends_on "ocaml@4" => :build # FIXME: pinned ppx_deriving.5.2.1 not compatible with OCaml >= 5.3
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  # Workaround for error due to `-mpopcnt` on arm64 macOS with Xcode 16.3+.
  # TODO: Remove once base >= 0.17.3 or if fix is backported to 0.14 and released
  on_sequoia :or_newer do
    on_arm do
      resource "base" do
        url "https://ghfast.top/https://github.com/janestreet/base/archive/refs/tags/v0.16.4.tar.gz"
        sha256 "200c053b69c04dd5cdc5bcb3ae27d098a88a311fb48c28d6382abe76e2a588f5"

        patch do
          url "https://github.com/janestreet/base/commit/68f18ed6a5e94dda1ed423c3435d1515259dcc7d.patch?full_index=1"
          sha256 "054fc30c7e748b2ad8ba8e2b8eead1309b8d7229821b57478cb604d5da5b69c6"
        end
      end
    end
  end

  def install
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    ENV["OPAMVERBOSE"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    # Workaround for https://github.com/janestreet/base/issues/164
    if OS.mac? && MacOS.version >= :sequoia
      resource("base").stage do
        system "opam", "install", ".", "--yes", "--no-depexts", "--working-dir"
      end
    end
    system "bash", "-x", "scripts/install_build_deps.sh"
    system "opam", "exec", "dune", "subst"
    system "opam", "exec", "dune", "build", "@install"

    bin.install "_build/default/src/stanc/stanc.exe" => "stanc"
  end

  test do
    resource "homebrew-testfile" do
      url "https://ghfast.top/https://raw.githubusercontent.com/stan-dev/stanc3/2e833ac746a36cdde11b7041fe3a1771dec92ba6/test/integration/good/algebra_solver_good.stan"
      sha256 "44e66f05cc7be4d0e0a942b3de03aed1a2c2abd93dbd5607542051d9d6ae2a0b"
    end
    testpath.install resource("homebrew-testfile")

    system bin/"stanc", "algebra_solver_good.stan"
    assert_path_exists testpath/"algebra_solver_good.hpp"

    assert_match "stanc3 v#{version}", shell_output("#{bin}/stanc --version")
  end
end