class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "b3a874084ee2553bb0945366709da60a4f3d6bc2ad2f45515e71e76878a14836"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a98bda75381af2ab60f9fe5603b4f5ba43a7915c234f9b46f0cc0234757fbc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346f29fe1e9989afc4dbe09abaaa5f5bc1ff30433577bdd4a794a493eb8a57b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0ea2127cc988ec6c0b021870466aa48e4831795af608370e42fef9e8ec10879"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bee610417669b7c4a50c03f7b3a58bbc15b679e24d1ed47a70b43f55092a3f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93cf405a1966b20ca2254dcf843f0d2a5c9ddebb5020634528eaa007b7eb4e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "683541cb2e49881ec2ed974f2bcba0111728114c16d17531977c77c342ac158a"
  end

  depends_on "mypy" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")

    # Work around zubanls not reading ZUBAN_TYPESHED (https://github.com/zubanls/zuban/issues/53)
    (typeshed = libexec/"lib/python3/site-packages/zuban/typeshed").mkpath
    cp_r Formula["mypy"].opt_libexec.glob("lib/python*/site-packages/mypy/typeshed").first.children, typeshed
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: typeshed
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