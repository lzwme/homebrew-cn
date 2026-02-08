class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.5.0",
    revision: "adb7937b1e96d72643fffcab6678e2c882a1fdc2"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c12b0bc8949490923d16f0c74b8ec99d229a993bb636a1e29da218f77049dc95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2b57dfc0a3e1e05a573ca9bc1dbb75eab747039e06e912283c6a35683893603"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8396cc9c75b77e4f48bfbe0f8c6ff4e4927ed606d0f5a6fd7b2f5df8dbb7364d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8642d432958ff01972626efed8100444a783527efd49f1b8c5e35c70989fb7a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1a69129d4d129e871e02c4c054bdaf64e4d55003ca79b8dafc588831da34e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4b437b192d514d878de4e42d29e19faae0c97f0394a638a110fa920df47b43b"
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