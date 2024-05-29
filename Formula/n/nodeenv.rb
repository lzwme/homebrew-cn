class Nodeenv < Formula
  include Language::Python::Shebang

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://github.com/ekalinin/nodeenv/archive/refs/tags/1.9.0.tar.gz"
  sha256 "af453a39935a4cb64dbf891f5487de9f0c2668375f296352730af1cb2d425df6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4df910878643ca03344ed29459cdc09ae6d630ad8cfdc3cf920cb05214ce916d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4df910878643ca03344ed29459cdc09ae6d630ad8cfdc3cf920cb05214ce916d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4df910878643ca03344ed29459cdc09ae6d630ad8cfdc3cf920cb05214ce916d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4df910878643ca03344ed29459cdc09ae6d630ad8cfdc3cf920cb05214ce916d"
    sha256 cellar: :any_skip_relocation, ventura:        "4df910878643ca03344ed29459cdc09ae6d630ad8cfdc3cf920cb05214ce916d"
    sha256 cellar: :any_skip_relocation, monterey:       "4df910878643ca03344ed29459cdc09ae6d630ad8cfdc3cf920cb05214ce916d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "017719c5fec3c4f328ce9089f7c18624e94bc28f98aee63e119c53db99f01819"
  end

  uses_from_macos "python"

  def install
    if OS.linux? || MacOS.version >= :catalina
      rewrite_shebang detected_python_shebang(use_python_from_path: true), "nodeenv.py"
    end
    bin.install "nodeenv.py" => "nodeenv"
  end

  test do
    system bin/"nodeenv", "--node=16.0.0", "--prebuilt", "env-16.0.0-prebuilt"
    # Dropping into the virtualenv itself requires sourcing activate which
    # isn't easy to deal with. This ensures current Node installed & functional.
    ENV.prepend_path "PATH", testpath/"env-16.0.0-prebuilt/bin"

    (testpath/"test.js").write "console.log('hello');"
    assert_match "hello", shell_output("node test.js")
    assert_match "v16.0.0", shell_output("node -v")
  end
end