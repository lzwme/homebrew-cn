class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "54e6161a230ab898a0845f6617cc162cf777306c06124d1454ba1415028a2f08"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a7378ced570613133c1bedd9c03e7fc92b2c5209ec1ff65ed69267965e884df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72cc747e326d800dd25591e59af0365f0be42e0d19aed02b632cd88e6aa5190f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f1562e6403256eea609ce01af61e0a94775d8c27bcc5098c165cea0f56aebf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa6f7157f88b83eebf11e159910384ff8a52a685d368bb91ca4cabee4c9533d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01c0f810739234fea3236a3bec66362b2cd9965cf0459621aadd20c5c61cf5cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c92e91e0a106c01373a44247eedb139f7e5a166907a16cfd7a9f54085d82280"
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